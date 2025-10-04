class TransactionEntity {
  final String? id;
  final String category;
  final String description;
  final double amount;
  final bool isIncome;
  final String icon;
  final DateTime date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TransactionEntity({
    this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.isIncome,
    required this.icon,
    required this.date,
    this.createdAt,
    this.updatedAt,
  });
}