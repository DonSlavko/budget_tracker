import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/transactions_provider.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime _selectedMonth = DateTime.now();
  int _selectedMonthIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TransactionsProvider>(
        builder: (context, transactionsProvider, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBalanceTrendCard(context, transactionsProvider),
                const SizedBox(height: 24),
                _buildCategoryBreakdown(context, transactionsProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBalanceTrendCard(BuildContext context, TransactionsProvider provider) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context);
    
    // Get the last 6 months
    final now = DateTime.now();
    final months = List.generate(6, (index) {
      return DateTime(now.year, now.month - index, 1);
    }).reversed.toList();
    
    // Calculate monthly expenses
    final monthlyExpenses = <DateTime, double>{};
    for (var month in months) {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);
      
      final monthTransactions = provider.getTransactionsByDateRange(startOfMonth, endOfMonth)
          .where((t) => t.type == TransactionType.expense)
          .toList();
      
      monthlyExpenses[month] = monthTransactions.fold(0.0, (sum, t) => sum + t.amount);
    }
    
    // Calculate max expense for chart scaling
    final maxExpense = monthlyExpenses.values.isEmpty 
        ? 1000.0 
        : monthlyExpenses.values.reduce((a, b) => a > b ? a : b);
    
    // Check if all values are zero
    final bool allValuesAreZero = monthlyExpenses.values.every((value) => value == 0);
    
    // Ensure we have a non-zero interval for the grid
    final horizontalInterval = maxExpense > 0 ? maxExpense / 4 : 250.0;
    
    // Calculate percentage change from previous month
    double percentChange = 0;
    if (months.length >= 2) {
      final currentMonthExpense = monthlyExpenses[months.last] ?? 0;
      final previousMonthExpense = monthlyExpenses[months[months.length - 2]] ?? 0;
      
      if (previousMonthExpense > 0) {
        percentChange = ((currentMonthExpense - previousMonthExpense) / previousMonthExpense) * 100;
      }
    }
    
    // Format current month expense
    final currentMonthExpense = monthlyExpenses[months.last] ?? 0;
    final formattedExpense = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    ).format(currentMonthExpense);
    
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizations.translate('spendingForPast6Months'),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
              child: SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: horizontalInterval,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: theme.dividerColor.withOpacity(0.3),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    minY: allValuesAreZero ? -1 : 0,
                    maxY: allValuesAreZero ? 1 : null,
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 && value.toInt() < months.length) {
                              final month = months[value.toInt()];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  DateFormat('MMM').format(month),
                                  style: theme.textTheme.bodySmall,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: horizontalInterval,
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const SizedBox.shrink();
                            return SizedBox(
                              width: 60,
                              child: Text(
                                '${(value / 1000).toStringAsFixed(2)}k',
                                style: theme.textTheme.bodySmall,
                                overflow: TextOverflow.visible,
                                softWrap: false,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(months.length, (index) {
                          return FlSpot(
                            index.toDouble(),
                            allValuesAreZero ? 0 : (monthlyExpenses[months[index]] ?? 0),
                          );
                        }),
                        isCurved: true,
                        color: theme.colorScheme.primary,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: theme.colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: theme.colorScheme.surface,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final monthIndex = spot.x.toInt();
                            if (monthIndex >= 0 && monthIndex < months.length) {
                              final month = months[monthIndex];
                              final expense = monthlyExpenses[month] ?? 0;
                              
                              return LineTooltipItem(
                                '${DateFormat(appLocalizations.translate('monthYearFormat')).format(month)}\n',
                                theme.textTheme.bodySmall!,
                                children: [
                                  TextSpan(
                                    text: '\$${expense.toStringAsFixed(2)}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            }
                            return null;
                          }).toList();
                        },
                      ),
                      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                        if (event is FlTapUpEvent && touchResponse?.lineBarSpots != null && touchResponse!.lineBarSpots!.isNotEmpty) {
                          final touchedSpot = touchResponse.lineBarSpots!.first;
                          final monthIndex = touchedSpot.x.toInt();
                          if (monthIndex >= 0 && monthIndex < months.length) {
                            setState(() {
                              _selectedMonth = months[monthIndex];
                              _selectedMonthIndex = monthIndex;
                            });
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(BuildContext context, TransactionsProvider provider) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context);
    
    // Get transactions for the selected month
    final startOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final endOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    
    final monthTransactions = provider.getTransactionsByDateRange(startOfMonth, endOfMonth)
        .where((t) => t.type == TransactionType.expense)
        .toList();
    
    // Group by category
    final categoryExpenses = <String, double>{};
    for (var transaction in monthTransactions) {
      categoryExpenses[transaction.category] = (categoryExpenses[transaction.category] ?? 0) + transaction.amount;
    }
    
    // Sort categories by amount (descending)
    final sortedCategories = categoryExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Calculate total expenses for the month
    final totalExpenses = monthTransactions.fold(0.0, (sum, t) => sum + t.amount);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocalizations.translate('spendingByCategory'),
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          _getFormattedMonthYear(context, _selectedMonth),
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (monthTransactions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Column(
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 64,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    appLocalizations.translate('noExpenses'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: sortedCategories.length,
                itemBuilder: (context, index) {
                  final category = sortedCategories[index];
                  final percentage = totalExpenses > 0 ? (category.value / totalExpenses) * 100 : 0;
                  
                  return Padding(
                    padding: index == sortedCategories.length - 1 
                        ? EdgeInsets.zero 
                        : const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category.key,
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              '\$${category.value.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: theme.colorScheme.surface,
                          color: Colors.primaries[index % Colors.primaries.length],
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  String _getFormattedMonthYear(BuildContext context, DateTime month) {
    final appLocalizations = AppLocalizations.of(context);
    final monthIndex = month.month - 1; // 0-based index for months
    final monthNames = [
      appLocalizations.translate('january'),
      appLocalizations.translate('february'),
      appLocalizations.translate('march'),
      appLocalizations.translate('april'),
      appLocalizations.translate('may'),
      appLocalizations.translate('june'),
      appLocalizations.translate('july'),
      appLocalizations.translate('august'),
      appLocalizations.translate('september'),
      appLocalizations.translate('october'),
      appLocalizations.translate('november'),
      appLocalizations.translate('december')
    ];
    
    return '${monthNames[monthIndex]} ${month.year}';
  }
} 