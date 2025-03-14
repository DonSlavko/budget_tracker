import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../providers/transactions_provider.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class AddTransactionSheet extends StatefulWidget {
  final Transaction? transaction;

  const AddTransactionSheet({
    super.key,
    this.transaction,
  });

  static Future<void> show(BuildContext context, {Transaction? transaction}) {
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
            child: AddTransactionSheet(transaction: transaction),
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
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedCategory = '';
  TransactionType _selectedType = TransactionType.expense;
  DateTime _selectedDate = DateTime.now();
  bool _isEditing = false;
  late String _transactionId;

  List<String> _getExpenseCategories(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    return [
      appLocalizations.translate('foodAndDrinks'),
      appLocalizations.translate('transportation'),
      appLocalizations.translate('housing'),
      appLocalizations.translate('utilities'),
      appLocalizations.translate('shopping'),
      appLocalizations.translate('entertainment'),
      appLocalizations.translate('healthcare'),
      appLocalizations.translate('education'),
      appLocalizations.translate('other'),
    ];
  }

  List<String> _getIncomeCategories(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    return [
      appLocalizations.translate('salary'),
      appLocalizations.translate('freelance'),
      appLocalizations.translate('investment'),
      appLocalizations.translate('business'),
      appLocalizations.translate('rental'),
      appLocalizations.translate('gift'),
      appLocalizations.translate('other'),
    ];
  }

  List<String> _getCurrentCategories(BuildContext context) {
    return _selectedType == TransactionType.expense 
        ? _getExpenseCategories(context) 
        : _getIncomeCategories(context);
  }

  @override
  void initState() {
    super.initState();
    // Initialize with existing transaction data if editing
    if (widget.transaction != null) {
      _isEditing = true;
      _transactionId = widget.transaction!.id;
      _amountController.text = widget.transaction!.amount.toString();
      _selectedType = widget.transaction!.type;
      _selectedCategory = widget.transaction!.category;
      _selectedDate = widget.transaction!.date;
      if (widget.transaction!.note != null) {
        _noteController.text = widget.transaction!.note!;
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Parse the amount and ensure it has exactly 2 decimal places
      final amountText = _amountController.text;
      double amount;
      
      if (amountText.contains('.')) {
        // If there's a decimal point, ensure exactly 2 decimal places
        final parts = amountText.split('.');
        final integerPart = parts[0];
        var decimalPart = parts[1];
        
        // Pad with zeros if needed
        if (decimalPart.length == 1) {
          decimalPart += '0';
        }
        
        amount = double.parse('$integerPart.$decimalPart');
      } else {
        // If there's no decimal point, add .00
        amount = double.parse('$amountText.00');
      }
      
      final transaction = Transaction(
        id: _isEditing ? _transactionId : const Uuid().v4(),
        title: _selectedCategory,
        amount: amount,
        type: _selectedType,
        category: _selectedCategory,
        date: _selectedDate,
        note: _noteController.text.isEmpty ? null : _noteController.text,
      );

      final provider = Provider.of<TransactionsProvider>(context, listen: false);
      
      if (_isEditing) {
        provider.updateTransaction(transaction);
      } else {
        provider.addTransaction(transaction);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocalizations = AppLocalizations.of(context);
    
    // Initialize the selected category if it's empty
    if (_selectedCategory.isEmpty) {
      _selectedCategory = _getCurrentCategories(context).first;
    }
    
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
                  _isEditing 
                      ? appLocalizations.translate('editTransaction')
                      : appLocalizations.translate('addTransaction'),
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
                      segments: [
                        ButtonSegment<TransactionType>(
                          value: TransactionType.expense,
                          label: Text(appLocalizations.translate('expense')),
                          icon: const Icon(
                            Icons.arrow_downward,
                            color: AppTheme.errorColor,
                          ),
                        ),
                        ButtonSegment<TransactionType>(
                          value: TransactionType.income,
                          label: Text(appLocalizations.translate('income')),
                          icon: const Icon(
                            Icons.arrow_upward,
                            color: AppTheme.successColor,
                          ),
                        ),
                      ],
                      selected: {_selectedType},
                      onSelectionChanged: (Set<TransactionType> newSelection) {
                        setState(() {
                          _selectedType = newSelection.first;
                          _selectedCategory = _getCurrentCategories(context).first;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration: InputDecoration(
                      prefixText: '\$  ',
                      hintText: appLocalizations.translate('amount'),
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
                        return appLocalizations.translate('pleaseEnterAmount');
                      }
                      
                      final amountRegex = RegExp(r'^\d+(\.\d{1,2})?$');
                      if (!amountRegex.hasMatch(value)) {
                        return appLocalizations.translate('pleaseEnterValidNumber');
                      }
                      
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return appLocalizations.translate('pleaseEnterValidNumber');
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
                        hintText: appLocalizations.translate('category'),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: theme.hintColor),
                      ),
                      items: _getCurrentCategories(context).map((category) {
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
                        helpText: appLocalizations.translate('selectDate'),
                        cancelText: appLocalizations.translate('cancel'),
                        confirmText: appLocalizations.translate('ok'),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: Theme.of(context).colorScheme.copyWith(
                                primary: theme.colorScheme.primary,
                                onPrimary: theme.colorScheme.onPrimary,
                                surface: theme.cardColor,
                                onSurface: theme.colorScheme.onSurface,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: theme.colorScheme.primary,
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
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
                            appLocalizations.translate('date'),
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
                    controller: _noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 48),
                        child: Icon(Icons.description_outlined, color: theme.iconTheme.color),
                      ),
                      hintText: appLocalizations.translate('descriptionOptional'),
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
                        _isEditing 
                            ? appLocalizations.translate('save')
                            : appLocalizations.translate('add'),
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