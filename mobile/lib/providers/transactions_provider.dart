import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class TransactionsProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  final String _storageKey = 'transactions';
  late SharedPreferences _prefs;

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

  Future<void> loadTransactions() async {
    _prefs = await SharedPreferences.getInstance();
    final String? transactionsJson = _prefs.getString(_storageKey);
    if (transactionsJson != null) {
      final List<dynamic> decodedList = json.decode(transactionsJson);
      _transactions = decodedList
          .map((item) => Transaction.fromJson(item))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    }
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

  Future<void> _saveTransactions() async {
    final String encodedData = json.encode(
      _transactions.map((transaction) => transaction.toJson()).toList(),
    );
    await _prefs.setString(_storageKey, encodedData);
  }

  List<Transaction> getTransactionsByCategory(String category) {
    return _transactions.where((t) => t.category == category).toList();
  }

  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _transactions
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .toList();
  }
} 