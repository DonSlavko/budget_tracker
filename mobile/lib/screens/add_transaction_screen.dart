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
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Add Transaction',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
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
                      color: Colors.grey[100],
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
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors.white;
                            }
                            return Colors.transparent;
                          },
                        ),
                        foregroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors.black87;
                            }
                            return Colors.black54;
                          },
                        ),
                        side: MaterialStateProperty.all(BorderSide.none),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 14),
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: MaterialStateProperty.all(
                          const Size(0, 48),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixText: '\$  ',
                      hintText: 'Amount',
                      errorStyle: const TextStyle(color: Colors.red),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
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
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      icon: const Icon(Icons.expand_more),
                      isExpanded: true,
                      decoration: const InputDecoration(
                        hintText: 'Category',
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: InputBorder.none,
                      ),
                      items: _currentCategories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
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
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _selectedDate.toString().split(' ')[0],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.calendar_today, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 48),
                        child: Icon(Icons.description_outlined),
                      ),
                      hintText: 'Description (Optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _submitForm,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue[50],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.blue,
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