import 'package:flutter/foundation.dart';
import '../../data/datasources/transaction_remote_datasource.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepositoryImpl(
    remoteDataSource: TransactionRemoteDataSource(),
  );

  List<TransactionEntity> _transactions = [];
  bool _isLoading = false;
  String? _error;

  List<TransactionEntity> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get all transactions
  Future<void> getTransactions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _transactions = await _repository.getTransactions();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get transactions by month
  Future<void> getTransactionsByMonth(int month, int year) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _transactions = await _repository.getTransactionsByMonth(month, year);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add transaction
  Future<bool> addTransaction(TransactionEntity transaction) async {
    try {
      await _repository.addTransaction(transaction);
      await getTransactions(); // Refresh list
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update transaction
  Future<bool> updateTransaction(TransactionEntity transaction) async {
    try {
      await _repository.updateTransaction(transaction);
      await getTransactions(); // Refresh list
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete transaction
  Future<bool> deleteTransaction(String id) async {
    try {
      await _repository.deleteTransaction(id);
      await getTransactions(); // Refresh list
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Watch transactions (real-time)
  void watchTransactions() {
    _repository.watchTransactions().listen(
      (transactions) {
        _transactions = transactions;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Calculate statistics
  double get totalIncome {
    return _transactions
        .where((t) => t.isIncome)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return _transactions
        .where((t) => !t.isIncome)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get balance => totalIncome - totalExpense;
}