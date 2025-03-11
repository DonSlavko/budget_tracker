import 'package:uuid/uuid.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final TransactionType type;
  final String? note;

  Transaction({
    String? id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    this.note,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'type': type.toString(),
      'note': note,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      category: json['category'],
      type: json['type'] == 'TransactionType.income'
          ? TransactionType.income
          : TransactionType.expense,
      note: json['note'],
    );
  }
} 