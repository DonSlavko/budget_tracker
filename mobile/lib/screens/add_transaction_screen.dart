import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../providers/transactions_provider.dart';
import '../theme/app_theme.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const AddTransactionSheet(),
          ),
        );
      },
    );
  }

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = '';
  TransactionType _selectedType = TransactionType.expense;
  DateTime _selectedDate = DateTime.now();

  final List<String> _expenseCategories = [
    'Food & Drinks',
    'Transportation',
    'Housing',
    'Utilities',
    'Shopping',
    'Entertainment',
    'Healthcare',
    'Education',
    'Other',
  ];

  final List<String> _incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Business',
    'Rental',
    'Gift',
    'Other',
  ];

  List<String> get _currentCategories =>
      _selectedType == TransactionType.expense ? _expenseCategories : _incomeCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategory = _expenseCategories.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final transaction = Transaction(
        id: const Uuid().v4(),
        title: _titleController.text.isEmpty ? _selectedCategory : _titleController.text,
        amount: double.parse(_amountController.text),
        type: _selectedType,
        category: _selectedCategory,
        date: _selectedDate,
      );

      Provider.of<TransactionsProvider>(context, listen: false)
          .addTransaction(transaction);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Add Transaction',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(width: 48), // Balance the title
              ],
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: theme.inputDecorationTheme.fillColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SegmentedButton<TransactionType>(
                      segments: const [
                        ButtonSegment<TransactionType>(
                          value: TransactionType.expense,
                          label: Text('Expense'),
                          icon: Icon(
                            Icons.arrow_downward,
                            color: AppTheme.errorColor,
                          ),
                        ),
                        ButtonSegment<TransactionType>(
                          value: TransactionType.income,
                          label: Text('Income'),
                          icon: Icon(
                            Icons.arrow_upward,
                            color: AppTheme.successColor,
                          ),
                        ),
                      ],
                      selected: {_selectedType},
                      onSelectionChanged: (Set<TransactionType> newSelection) {
                        setState(() {
                          _selectedType = newSelection.first;
                          _selectedCategory = _currentCategories.first;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixText: '\$  ',
                      hintText: 'Amount',
                      errorStyle: TextStyle(color: theme.colorScheme.error),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.inputDecorationTheme.fillColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.inputDecorationTheme.fillColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      icon: Icon(Icons.expand_more, color: theme.iconTheme.color),
                      isExpanded: true,
                      dropdownColor: theme.cardColor,
                      decoration: InputDecoration(
                        hintText: 'Category',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: theme.hintColor),
                      ),
                      items: _currentCategories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category, style: theme.textTheme.bodyLarge),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedCategory = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.inputDecorationTheme.fillColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Date',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _selectedDate.toString().split(' ')[0],
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.calendar_today, size: 20, color: theme.iconTheme.color),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 48),
                        child: Icon(Icons.description_outlined, color: theme.iconTheme.color),
                      ),
                      hintText: 'Description (Optional)',
                      hintStyle: TextStyle(color: theme.hintColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.inputDecorationTheme.fillColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _submitForm,
                      style: TextButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 