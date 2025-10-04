import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    return await remoteDataSource.getTransactions();
  }

  @override
  Future<List<TransactionEntity>> getTransactionsByMonth(
    int month,
    int year,
  ) async {
    return await remoteDataSource.getTransactionsByMonth(month, year);
  }

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    await remoteDataSource.addTransaction(model);
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    await remoteDataSource.updateTransaction(model);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await remoteDataSource.deleteTransaction(id);
  }

  @override
  Stream<List<TransactionEntity>> watchTransactions() {
    return remoteDataSource.watchTransactions();
  }
}