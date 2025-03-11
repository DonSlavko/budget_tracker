import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/transactions_provider.dart';
import '../models/transaction.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsProvider>(
      builder: (context, transactionsProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
              _buildBalanceCard(context, transactionsProvider),
              const SizedBox(height: 24),
              Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              _buildRecentTransactions(context, transactionsProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard(BuildContext context, TransactionsProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '\$${provider.totalBalance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: provider.totalBalance >= 0
                        ? AppTheme.incomeColor
                        : AppTheme.expenseColor,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBalanceItem(
                  context,
                  'Income',
                  provider.totalIncome,
                  AppTheme.incomeColor,
                ),
                _buildBalanceItem(
                  context,
                  'Expenses',
                  provider.totalExpenses,
                  AppTheme.expenseColor,
                ),
              ],
            ),
          ],
        ),
      ),
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
    final recentTransactions = provider.transactions.take(5).toList();

    if (recentTransactions.isEmpty) {
      return Center(
        child: Text(
          'No transactions yet',
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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transaction.type == TransactionType.income
              ? AppTheme.incomeColor.withOpacity(0.1)
              : AppTheme.expenseColor.withOpacity(0.1),
          child: Icon(
            transaction.type == TransactionType.income
                ? Icons.arrow_downward
                : Icons.arrow_upward,
            color: transaction.type == TransactionType.income
                ? AppTheme.incomeColor
                : AppTheme.expenseColor,
          ),
        ),
        title: Text(transaction.title),
        subtitle: Text(transaction.category),
        trailing: Text(
          '\$${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: transaction.type == TransactionType.income
                ? AppTheme.incomeColor
                : AppTheme.expenseColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
} 