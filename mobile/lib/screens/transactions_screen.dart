import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/transactions_provider.dart';
import '../models/transaction.dart';
import '../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../widgets/transaction_details_modal.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late int selectedYear;
  late int selectedMonth;
  bool isYearlyView = false;
  
  // We'll use the translated month names from AppLocalizations
  List<String> getMonthNames(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    return [
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
  }

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
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context);
    final months = getMonthNames(context);
    
    return Scaffold(
      body: Consumer<TransactionsProvider>(
        builder: (context, transactionsProvider, child) {
          return Column(
            children: [
              // Month and Year selector
              Padding(
                padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 16),
                child: Card(
                  elevation: 0,
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Month Dropdown
                            if (!isYearlyView) ...[
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.inputDecorationTheme.fillColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: theme.dividerColor,
                                    width: 1,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: DropdownButton<int>(
                                  value: selectedMonth,
                                  underline: const SizedBox(),
                                  dropdownColor: theme.cardColor,
                                  items: List.generate(12, (index) {
                                    return DropdownMenuItem(
                                      value: index + 1,
                                      child: Text(
                                        months[index],
                                        style: theme.textTheme.bodyLarge,
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
                                color: theme.inputDecorationTheme.fillColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: theme.dividerColor,
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: DropdownButton<int>(
                                value: selectedYear,
                                underline: const SizedBox(),
                                dropdownColor: theme.cardColor,
                                items: _getYearsList().map((year) {
                                  return DropdownMenuItem(
                                    value: year,
                                    child: Text(
                                      year.toString(),
                                      style: theme.textTheme.bodyLarge,
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
                        const SizedBox(height: 16),
                        // Yearly View Toggle
                        InkWell(
                          onTap: () {
                            setState(() {
                              isYearlyView = !isYearlyView;
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isYearlyView ? theme.colorScheme.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isYearlyView ? theme.colorScheme.primary : theme.dividerColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isYearlyView ? Icons.check_circle : Icons.circle_outlined,
                                  size: 20,
                                  color: isYearlyView ? theme.colorScheme.onPrimary : theme.textTheme.bodySmall?.color,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  appLocalizations.translate('yearlyView'),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: isYearlyView ? theme.colorScheme.onPrimary : theme.textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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

  Widget _buildTransactionsList(BuildContext context, TransactionsProvider provider) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context);
    final transactions = provider.transactions;
    final months = getMonthNames(context);
    
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          appLocalizations.translate('noTransactionsFound'),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      );
    }

    final filteredTransactions = transactions.where((transaction) {
      if (isYearlyView) {
        return transaction.date.year == selectedYear;
      } else {
        return transaction.date.year == selectedYear && 
               transaction.date.month == selectedMonth;
      }
    }).toList();

    if (filteredTransactions.isEmpty) {
      String message;
      if (isYearlyView) {
        // For yearly view, we need to replace {year} with the actual year
        message = appLocalizations.translate('noTransactionsInYear').replaceAll('{year}', selectedYear.toString());
      } else {
        // For monthly view, we need to replace {month} and {year} with the actual values
        message = appLocalizations.translate('noTransactionsInMonth')
            .replaceAll('{month}', months[selectedMonth - 1])
            .replaceAll('{year}', selectedYear.toString());
      }
      
      return Center(
        child: Text(
          message,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        return _buildTransactionItem(context, filteredTransactions[index]);
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