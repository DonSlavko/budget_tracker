import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/transactions_provider.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late int selectedYear;
  late int selectedMonth;
  bool isYearlyView = false;
  
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month;
  }

  List<int> _getYearsList() {
    final currentYear = DateTime.now().year;
    return List.generate(5, (index) => currentYear - index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TransactionsProvider>(
        builder: (context, transactionsProvider, child) {
          return Column(
            children: [
              // Month and Year selector
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Month Dropdown
                        if (!isYearlyView) ...[
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.inputFillColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButton<int>(
                              value: selectedMonth,
                              underline: const SizedBox(),
                              items: List.generate(12, (index) {
                                return DropdownMenuItem(
                                  value: index + 1,
                                  child: Text(
                                    months[index],
                                    style: AppTheme.bodyStyle,
                                  ),
                                );
                              }),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    selectedMonth = value;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        // Year Dropdown
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.inputFillColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton<int>(
                            value: selectedYear,
                            underline: const SizedBox(),
                            items: _getYearsList().map((year) {
                              return DropdownMenuItem(
                                value: year,
                                child: Text(
                                  year.toString(),
                                  style: AppTheme.bodyStyle,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedYear = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Yearly View Toggle
                    InkWell(
                      onTap: () {
                        setState(() {
                          isYearlyView = !isYearlyView;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isYearlyView ? AppTheme.primaryColor : AppTheme.inputFillColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isYearlyView ? AppTheme.primaryColor : AppTheme.borderColor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isYearlyView ? Icons.check_circle : Icons.circle_outlined,
                              size: 20,
                              color: isYearlyView ? Colors.white : AppTheme.secondaryTextColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Yearly View',
                              style: AppTheme.bodyStyle.copyWith(
                                color: isYearlyView ? Colors.white : AppTheme.secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Transactions list
              Expanded(
                child: _buildTransactionsList(context, transactionsProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTransactionsList(
    BuildContext context,
    TransactionsProvider provider,
  ) {
    final transactions = provider.transactions
        .where((t) =>
            t.date.year == selectedYear &&
            (isYearlyView || t.date.month == selectedMonth))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    if (transactions.isEmpty) {
      return Center(
        child: Text(
          isYearlyView 
              ? 'No transactions for $selectedYear'
              : 'No transactions for ${months[selectedMonth - 1]} $selectedYear',
          style: AppTheme.bodyStyle.copyWith(color: AppTheme.secondaryTextColor),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionItem(context, transaction);
      },
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.inputFillColor,
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
          style: AppTheme.subheadingStyle,
        ),
        subtitle: Text(
          DateFormat('MMM d, yyyy').format(transaction.date),
          style: AppTheme.captionStyle,
        ),
        trailing: Text(
          '${transaction.type == TransactionType.expense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
          style: AppTheme.bodyStyle.copyWith(
            color: transaction.type == TransactionType.income
                ? AppTheme.successColor
                : AppTheme.errorColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
} 