import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Row(
                children: [
                  Icon(Icons.arrow_back_ios),
                  SizedBox(width: 8),
                  Text("Activity", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),

              // Balance + Chart Card
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text("Current Balance", style: TextStyle(color: Colors.grey)),
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text("\$50,000", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 180,
                      child: PieChart(
                        PieChartData(
                          centerSpaceRadius: 50,
                          sections: [
                            PieChartSectionData(
                              value: 70,
                              color: Colors.indigo,
                              radius: 35,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: 30,
                              color: Colors.blueAccent,
                              radius: 35,
                              showTitle: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "\$2,482\nYour saving",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick Menu
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Quick Menu", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("See all", style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.account_balance_wallet, color: Colors.white, size: 32),
                          SizedBox(height: 8),
                          Text("Top up wallet\nMoney", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.pie_chart, color: Colors.black, size: 32),
                          SizedBox(height: 8),
                          Text("Create wallet\nBudget", textAlign: TextAlign.center, style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Payment History
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Payment History", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("See all", style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),
              const PaymentHistoryItem(title: "Spotify", dateTime: "21 Jan, 03:32 PM", amount: "-\$12"),
              const PaymentHistoryItem(title: "Netflix", dateTime: "20 Jan, 08:10 PM", amount: "-\$15"),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentHistoryItem extends StatelessWidget {
  final String title;
  final String dateTime;
  final String amount;

  const PaymentHistoryItem({
    super.key,
    required this.title,
    required this.dateTime,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(dateTime),
        trailing: Text(amount, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
