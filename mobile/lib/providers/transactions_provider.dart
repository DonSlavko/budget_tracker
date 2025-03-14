import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';

class TransactionsProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  final String _storageKey = 'transactions';
  late SharedPreferences _prefs;

  TransactionsProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await loadTransactions();
  }

  List<Transaction> get transactions => [..._transactions];

  double get totalBalance {
    return _transactions.fold(0, (sum, transaction) {
      return sum + (transaction.type == TransactionType.income
          ? transaction.amount
          : -transaction.amount);
    });
  }

  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalExpenses {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _transactions
        .where((t) => t.date.isAfter(start.subtract(const Duration(days: 1))) && 
                     t.date.isBefore(end.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<String> get categories {
    final categorySet = <String>{};
    for (var transaction in _transactions) {
      categorySet.add(transaction.category);
    }
    return categorySet.toList()..sort();
  }

  Map<String, double> getCategoryTotals(TransactionType type) {
    final totals = <String, double>{};
    final typeTransactions = _transactions.where((t) => t.type == type);
    
    for (var transaction in typeTransactions) {
      totals[transaction.category] = (totals[transaction.category] ?? 0) + transaction.amount;
    }
    
    return totals;
  }

  Future<void> loadTransactions() async {
    final String? transactionsJson = _prefs.getString(_storageKey);
    if (transactionsJson != null && transactionsJson.isNotEmpty) {
      try {
        final List<dynamic> decodedList = json.decode(transactionsJson);
        _transactions = decodedList
            .map((item) => Transaction.fromJson(item))
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
      } catch (e) {
        _transactions = [];
      }
    } else {
      _transactions = [];
    }
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    _transactions.insert(0, transaction);
    await _saveTransactions();
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((transaction) => transaction.id == id);
    await _saveTransactions();
    notifyListeners();
  }

  Future<void> updateTransaction(Transaction updatedTransaction) async {
    final index = _transactions.indexWhere((t) => t.id == updatedTransaction.id);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      await _saveTransactions();
      notifyListeners();
    }
  }

  Future<void> _saveTransactions() async {
    final String encodedData = json.encode(
      _transactions.map((transaction) => transaction.toJson()).toList(),
    );
    await _prefs.setString(_storageKey, encodedData);
  }

  List<Transaction> getTransactionsByCategory(String category) {
    return _transactions.where((t) => t.category == category).toList();
  }
} 