import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../providers/transactions_provider.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../screens/add_transaction_screen.dart';

class TransactionDetailsModal extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailsModal({
    super.key,
    required this.transaction,
  });

  static Future<void> show(BuildContext context, Transaction transaction) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: TransactionDetailsModal(transaction: transaction),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Stack(
        children: [
          // Close button at top right
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          
          // Main content
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaction Type and Category
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.category,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transaction.type == TransactionType.income
                              ? appLocalizations.translate('income')
                              : appLocalizations.translate('expense'),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: transaction.type == TransactionType.income
                                ? AppTheme.successColor
                                : AppTheme.errorColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Amount
              _buildDetailSection(
                context,
                title: appLocalizations.translate('amount'),
                content: '${transaction.type == TransactionType.expense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
                contentStyle: theme.textTheme.headlineMedium?.copyWith(
                  color: transaction.type == TransactionType.income
                      ? AppTheme.successColor
                      : AppTheme.errorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              // Date
              _buildDetailSection(
                context,
                title: appLocalizations.translate('date'),
                content: DateFormat(appLocalizations.translate('dateFormat')).format(transaction.date),
              ),
              
              // Description (if available)
              if (transaction.note != null && transaction.note!.isNotEmpty)
                _buildDetailSection(
                  context,
                  title: appLocalizations.translate('descriptionOptional'),
                  content: transaction.note!,
                ),
              
              const SizedBox(height: 16),
              
              // Edit and Delete buttons at bottom right
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Edit Button
                  _buildIconButton(
                    context,
                    icon: Icons.edit,
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      Navigator.pop(context);
                      // Open the AddTransactionSheet in edit mode
                      AddTransactionSheet.show(context, transaction: transaction);
                    },
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Delete Button
                  _buildIconButton(
                    context,
                    icon: Icons.delete,
                    color: AppTheme.errorColor,
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context, {
    required String title,
    required String content,
    TextStyle? contentStyle,
  }) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: contentStyle ?? theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: color,
        ),
        onPressed: onPressed,
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            appLocalizations.translate('deleteTransaction'),
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            appLocalizations.translate('deleteTransactionConfirmation'),
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the confirmation dialog
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurface.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    appLocalizations.translate('cancel'),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 16), // Add spacing between buttons
                TextButton(
                  onPressed: () {
                    // Delete the transaction
                    Provider.of<TransactionsProvider>(context, listen: false)
                        .deleteTransaction(transaction.id);
                    
                    Navigator.pop(context); // Close the confirmation dialog
                    Navigator.pop(context); // Close the transaction details modal
                    
                    // Show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(appLocalizations.translate('transactionDeleted')),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.all(10),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.errorColor.withOpacity(0.1),
                    foregroundColor: AppTheme.errorColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    appLocalizations.translate('delete'),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          buttonPadding: EdgeInsets.zero,
        );
      },
    );
  }
} 