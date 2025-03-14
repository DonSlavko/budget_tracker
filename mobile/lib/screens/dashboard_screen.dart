import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/transactions_provider.dart';
import '../models/transaction.dart';
import '../l10n/app_localizations.dart';
import 'add_transaction_screen.dart';
import '../widgets/transaction_details_modal.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<void> _refreshData() async {
    await Provider.of<TransactionsProvider>(context, listen: false).loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TransactionsProvider>(
        builder: (context, transactionsProvider, child) {
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBalanceCard(context, transactionsProvider),
                  const SizedBox(height: 24),
                  _buildExpenseChart(context, transactionsProvider),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context).translate('recentTransactions'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildRecentTransactions(context, transactionsProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, TransactionsProvider provider) {
    final appLocalizations = AppLocalizations.of(context);
    final transactions = provider.transactions;
    final totalBalance = transactions.fold(0.0, (sum, transaction) => 
      sum + (transaction.type == TransactionType.income ? transaction.amount : -transaction.amount));
    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    final totalExpenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizations.translate('totalBalance'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '\$${totalBalance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: totalBalance >= 0
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBalanceItem(
                  context,
                  appLocalizations.translate('income'),
                  totalIncome,
                  AppTheme.successColor,
                ),
                _buildBalanceItem(
                  context,
                  appLocalizations.translate('expenses'),
                  totalExpenses,
                  AppTheme.errorColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseChart(BuildContext context, TransactionsProvider provider) {
    final appLocalizations = AppLocalizations.of(context);
    final expenses = provider.transactions
        .where((t) => t.type == TransactionType.expense)
        .toList();

    if (expenses.isEmpty) {
      return const SizedBox.shrink();
    }

    // Group expenses by category
    final categoryExpenses = <String, double>{};
    for (var expense in expenses) {
      categoryExpenses[expense.category] = (categoryExpenses[expense.category] ?? 0) + expense.amount;
    }

    // Convert to pie chart data
    final pieData = categoryExpenses.entries.map((entry) {
      final color = Colors.primaries[categoryExpenses.keys.toList().indexOf(entry.key) % Colors.primaries.length];
      return PieChartSectionData(
        value: entry.value,
        title: '${entry.key}\n${(entry.value / expenses.fold(0.0, (sum, e) => sum + e.amount) * 100).toStringAsFixed(1)}%',
        color: color,
        radius: 100,
        titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocalizations.translate('expenseBreakdown'),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: pieData,
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceItem(
    BuildContext context,
    String label,
    double amount,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
              ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(
    BuildContext context,
    TransactionsProvider provider,
  ) {
    final appLocalizations = AppLocalizations.of(context);
    final now = DateTime.now();
    final recentTransactions = provider.transactions
        .where((t) => now.difference(t.date).inDays <= 14)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort by date, newest first

    if (recentTransactions.isEmpty) {
      return Center(
        child: Text(
          appLocalizations.translate('noRecentTransactions'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentTransactions.length,
      itemBuilder: (context, index) {
        final transaction = recentTransactions[index];
        return _buildTransactionItem(context, transaction);
      },
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            transaction.type == TransactionType.income
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            color: transaction.type == TransactionType.income
                ? AppTheme.successColor
                : AppTheme.errorColor,
            size: 24,
          ),
        ),
        title: Text(
          transaction.category,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat(appLocalizations.translate('dateFormat')).format(transaction.date),
          style: theme.textTheme.bodySmall,
        ),
        trailing: Text(
          '${transaction.type == TransactionType.expense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: transaction.type == TransactionType.income
                ? AppTheme.successColor
                : AppTheme.errorColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {
          TransactionDetailsModal.show(context, transaction);
        },
      ),
    );
  }
} 