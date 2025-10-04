import 'package:flutter/material.dart';
import 'package:finance_app/core/config/app_router.dart';
import 'package:finance_app/core/widgets/common_layout.dart';
import 'package:finance_app/core/widgets/content_container.dart';
import 'package:finance_app/core/widgets/main_layout.dart';
import 'package:finance_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_app/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  int currentMonthIndex = 0;
  List<MonthData> monthsData = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    await provider.getTransactions();
    _groupTransactionsByMonth();
  }

  void _groupTransactionsByMonth() {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    final transactions = provider.transactions;

    // Group transactions by month
    Map<String, List<TransactionEntity>> grouped = {};

    for (var transaction in transactions) {
      final key = '${transaction.date.year}-${transaction.date.month}';
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(transaction);
    }

    // Convert to MonthData list
    List<MonthData> months = [];
    grouped.forEach((key, transactions) {
      final parts = key.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);

      months.add(
        MonthData(
          monthName: 'Tháng $month',
          month: month,
          year: year,
          transactions: transactions,
        ),
      );
    });

    // Sort by date (newest first)
    months.sort((a, b) {
      if (a.year != b.year) return b.year.compareTo(a.year);
      return b.month.compareTo(a.month);
    });

    setState(() {
      monthsData = months;
    });
  }

  // Helper function to convert icon name to IconData
  IconData _getIconData(String iconName) {
    final iconMap = {
      'restaurant': Icons.restaurant,
      'shopping_cart': Icons.shopping_cart,
      'local_gas_station': Icons.local_gas_station,
      'electrical_services': Icons.electrical_services,
      'water_drop': Icons.water_drop,
      'home': Icons.home,
      'medical_services': Icons.medical_services,
      'school': Icons.school,
      'movie': Icons.movie,
      'flight_takeoff': Icons.flight_takeoff,
      'shopping_bag': Icons.shopping_bag,
      'work': Icons.work,
      'card_giftcard': Icons.card_giftcard,
      'computer': Icons.computer,
      'trending_up': Icons.trending_up,
      'sell': Icons.sell,
      'more_horiz': Icons.more_horiz,
    };
    return iconMap[iconName] ?? Icons.more_horiz;
  }

  Future<void> _navigateToAddTransaction() async {
    final result = await Navigator.pushNamed(context, AppRoutes.addTransaction);
    if (result == true) {
      // Reload transactions after adding new one
      _loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return MainLayout(
          currentIndex: 1,
          child: CommonLayout(
            title: "Giao dịch",
            child: Column(
              children: [
                // Balance Card Section
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildBalanceCard(provider),
                ),

                // Month Navigation
                if (monthsData.isNotEmpty) _buildMonthNavigation(),

                const SizedBox(height: 8),

                // Content Section
                Expanded(
                  child: ContentContainer(
                    child: Column(
                      children: [
                        // Danh sách transactions
                        Expanded(
                          child: provider.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : provider.error != null
                              ? _buildErrorWidget(provider.error!)
                              : monthsData.isEmpty
                              ? _buildEmptyState()
                              : _buildTransactionsList(),
                        ),

                        // Button nằm trong ContentContainer
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildAddButton(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard(TransactionProvider provider) {
    final balance = provider.balance;
    final totalIncome = provider.totalIncome;
    final totalExpense = provider.totalExpense;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Số dư hiện tại',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '₫${_formatCurrency(balance)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildBalanceItem(
                  'Thu nhập',
                  '₫${_formatCurrency(totalIncome)}',
                  Icons.arrow_upward,
                  Colors.green.shade300,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildBalanceItem(
                  'Chi tiêu',
                  '₫${_formatCurrency(totalExpense)}',
                  Icons.arrow_downward,
                  Colors.red.shade300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(
    String label,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          IconButton(
            onPressed: currentMonthIndex > 0
                ? () {
                    setState(() {
                      currentMonthIndex--;
                    });
                  }
                : null,
            icon: Icon(
              Icons.chevron_left,
              color: currentMonthIndex > 0 ? Colors.white : Colors.white38,
            ),
          ),

          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: monthsData.length,
              itemBuilder: (context, index) {
                final isSelected = index == currentMonthIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentMonthIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white.withOpacity(0.4)
                            : Colors.transparent,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        monthsData[index].monthName,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          IconButton(
            onPressed: currentMonthIndex < monthsData.length - 1
                ? () {
                    setState(() {
                      currentMonthIndex++;
                    });
                  }
                : null,
            icon: Icon(
              Icons.chevron_right,
              color: currentMonthIndex < monthsData.length - 1
                  ? Colors.white
                  : Colors.white38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    final currentMonth = monthsData[currentMonthIndex];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currentMonth.monthName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  '${currentMonth.transactions.length} giao dịch',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...currentMonth.transactions.map(
              (transaction) => _buildTransactionItem(transaction),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(TransactionEntity transaction) {
    final bool isIncome = transaction.isIncome;
    final String formattedAmount = isIncome
        ? '+₫${_formatCurrency(transaction.amount)}'
        : '-₫${_formatCurrency(transaction.amount)}';

    return Dismissible(
      key: Key(transaction.id ?? ''),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Xác nhận xóa'),
              content: const Text('Bạn có chắc chắn muốn xóa giao dịch này?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Xóa'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        final provider = Provider.of<TransactionProvider>(
          context,
          listen: false,
        );
        await provider.deleteTransaction(transaction.id!);
        _groupTransactionsByMonth();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xóa giao dịch'),
            backgroundColor: Colors.red,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF00D4AA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getIconData(transaction.icon),
                color: const Color(0xFF00D4AA),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  if (transaction.description.isNotEmpty)
                    Text(
                      transaction.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedAmount,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  '${transaction.date.day}/${transaction.date.month}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có giao dịch nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thêm giao dịch đầu tiên của bạn',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            'Đã xảy ra lỗi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadTransactions,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            ),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _navigateToAddTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00D4AA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Thêm giao dịch',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}

// Model cho dữ liệu tháng
class MonthData {
  final String monthName;
  final int month;
  final int year;
  final List<TransactionEntity> transactions;

  MonthData({
    required this.monthName,
    required this.month,
    required this.year,
    required this.transactions,
  });
}
