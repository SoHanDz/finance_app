import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    super.id,
    required super.category,
    required super.description,
    required super.amount,
    required super.isIncome,
    required super.icon,
    required super.date,
    super.createdAt,
    super.updatedAt,
  });

  // From JSON (Firestore)
  factory TransactionModel.fromJson(Map<String, dynamic> json, String id) {
    return TransactionModel(
      id: id,
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      isIncome: json['isIncome'] ?? false,
      icon: json['icon'] ?? 'more_horiz',
      date: (json['date'] as Timestamp).toDate(),
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] as Timestamp).toDate() 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? (json['updatedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  // To JSON (Firestore)
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'description': description,
      'amount': amount,
      'isIncome': isIncome,
      'icon': icon,
      'date': Timestamp.fromDate(date),
      'createdAt': createdAt != null 
          ? Timestamp.fromDate(createdAt!) 
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // From Entity
  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      category: entity.category,
      description: entity.description,
      amount: entity.amount,
      isIncome: entity.isIncome,
      icon: entity.icon,
      date: entity.date,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}