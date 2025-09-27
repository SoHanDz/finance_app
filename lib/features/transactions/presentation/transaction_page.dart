import 'package:flutter/material.dart';
// import 'package:finance_app/core/config/app_router.dart';
import 'package:finance_app/core/widgets/common_layout.dart';
import 'package:finance_app/core/widgets/content_container.dart';
import 'package:finance_app/core/widgets/main_layout.dart';

// Model cho transaction
class Transaction {
  final String category;
  final String description;
  final double amount;
  final IconData icon;
  final DateTime date;

  Transaction({
    required this.category,
    required this.description,
    required this.amount,
    required this.icon,
    required this.date,
  });
}

// Model cho dữ liệu tháng
class MonthData {
  final String monthName;
  final int month;
  final int year;
  final List<Transaction> transactions;

  MonthData({
    required this.monthName,
    required this.month,
    required this.year,
    required this.transactions,
  });
}

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  int currentMonthIndex = 0;
  
  // Dữ liệu giả cho nhiều tháng
  List<MonthData> get monthsData => [
    MonthData(
      monthName: 'Tháng 1',
      month: 1,
      year: 2024,
      transactions: [
        Transaction(
          category: 'Lương tháng 1',
          description: 'Công ty ABC',
          amount: 15000000,
          icon: Icons.work,
          date: DateTime(2024, 1, 5),
        ),
        Transaction(
          category: 'Ăn sáng',
          description: 'Cà phê Highlands',
          amount: -85000,
          icon: Icons.restaurant,
          date: DateTime(2024, 1, 10),
        ),
        Transaction(
          category: 'Mua sắm',
          description: 'Siêu thị Coopmart',
          amount: -500000,
          icon: Icons.shopping_cart,
          date: DateTime(2024, 1, 15),
        ),
        Transaction(
          category: 'Tiền điện',
          description: 'EVN HCMC',
          amount: -350000,
          icon: Icons.electrical_services,
          date: DateTime(2024, 1, 20),
        ),
      ],
    ),
    MonthData(
      monthName: 'Tháng 2',
      month: 2,
      year: 2024,
      transactions: [
        Transaction(
          category: 'Lương tháng 2',
          description: 'Công ty ABC',
          amount: 15000000,
          icon: Icons.work,
          date: DateTime(2024, 2, 5),
        ),
        Transaction(
          category: 'Ăn trưa',
          description: 'Nhà hàng Sài Gòn',
          amount: -150000,
          icon: Icons.restaurant,
          date: DateTime(2024, 2, 8),
        ),
        Transaction(
          category: 'Xăng xe',
          description: 'Petrolimex',
          amount: -450000,
          icon: Icons.local_gas_station,
          date: DateTime(2024, 2, 12),
        ),
        Transaction(
          category: 'Tiền nước',
          description: 'SAWACO',
          amount: -120000,
          icon: Icons.water_drop,
          date: DateTime(2024, 2, 18),
        ),
        Transaction(
          category: 'Freelance',
          description: 'Dự án website',
          amount: 3000000,
          icon: Icons.computer,
          date: DateTime(2024, 2, 25),
        ),
      ],
    ),
    MonthData(
      monthName: 'Tháng 3',
      month: 3,
      year: 2024,
      transactions: [
        Transaction(
          category: 'Ăn sáng',
          description: 'Cà phê Highlands',
          amount: -85000,
          icon: Icons.restaurant,
          date: DateTime(2024, 3, 2),
        ),
        Transaction(
          category: 'Lương tháng 3',
          description: 'Công ty ABC',
          amount: 15000000,
          icon: Icons.work,
          date: DateTime(2024, 3, 5),
        ),
        Transaction(
          category: 'Xăng xe',
          description: 'Petrolimex',
          amount: -450000,
          icon: Icons.local_gas_station,
          date: DateTime(2024, 3, 10),
        ),
        Transaction(
          category: 'Mua quần áo',
          description: 'Uniqlo',
          amount: -800000,
          icon: Icons.shopping_bag,
          date: DateTime(2024, 3, 15),
        ),
        Transaction(
          category: 'Tiền thuê nhà',
          description: 'Chủ nhà',
          amount: -8000000,
          icon: Icons.home,
          date: DateTime(2024, 3, 20),
        ),
      ],
    ),
    MonthData(
      monthName: 'Tháng 4',
      month: 4,
      year: 2024,
      transactions: [
        Transaction(
          category: 'Lương tháng 4',
          description: 'Công ty ABC',
          amount: 15000000,
          icon: Icons.work,
          date: DateTime(2024, 4, 5),
        ),
        Transaction(
          category: 'Đi du lịch',
          description: 'Vũng Tàu Resort',
          amount: -2500000,
          icon: Icons.flight_takeoff,
          date: DateTime(2024, 4, 12),
        ),
        Transaction(
          category: 'Ăn tối',
          description: 'BBQ House',
          amount: -350000,
          icon: Icons.restaurant,
          date: DateTime(2024, 4, 18),
        ),
        Transaction(
          category: 'Bán đồ cũ',
          description: 'Facebook Marketplace',
          amount: 500000,
          icon: Icons.sell,
          date: DateTime(2024, 4, 25),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 1, // Giao dịch tab
      child: CommonLayout(
        title: "Giao dịch",
        child: Column(
          children: [
            // Balance Card Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: _buildBalanceCard(),
            ),
            
            // Month Navigation
            _buildMonthNavigation(),

            const SizedBox(height: 8),

            // Content Section
            Expanded(
              child: ContentContainer(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRecentTransactions(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Số dư hiện tại',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '₫25,450,000',
            style: TextStyle(
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
                  '₫15,200,000',
                  Icons.arrow_upward,
                  Colors.green.shade300,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildBalanceItem(
                  'Chi tiêu',
                  '₫8,750,000',
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

  Widget _buildBalanceItem(String label, String amount, IconData icon, Color color) {
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
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
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
          // Nút Previous
          IconButton(
            onPressed: currentMonthIndex > 0 ? () {
              setState(() {
                currentMonthIndex--;
              });
            } : null,
            icon: Icon(
              Icons.chevron_left,
              color: currentMonthIndex > 0 ? Colors.white : Colors.white38,
            ),
          ),
          
          // Danh sách tháng có thể scroll
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Nút Next
          IconButton(
            onPressed: currentMonthIndex < monthsData.length - 1 ? () {
              setState(() {
                currentMonthIndex++;
              });
            } : null,
            icon: Icon(
              Icons.chevron_right,
              color: currentMonthIndex < monthsData.length - 1 ? Colors.white : Colors.white38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    final currentMonth = monthsData[currentMonthIndex];
    
    return Column(
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
        ...currentMonth.transactions.map((transaction) => 
          _buildTransactionItem(transaction)),
      ],
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final bool isIncome = transaction.amount > 0;
    final String formattedAmount = isIncome 
        ? '+₫${transaction.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}'
        : '-₫${(-transaction.amount).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
    
    return Container(
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
              transaction.icon,
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
          Text(
            formattedAmount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}