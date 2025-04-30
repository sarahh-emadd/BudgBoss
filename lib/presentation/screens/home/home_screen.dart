import 'package:budget_boss_new/presentation/screens/activityscreen.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
  child: SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Greeting and icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.settings),
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.notifications_active),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Hello,\nDR. Youssef!',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
              ),
              const SizedBox(height: 20),

              // Current Balance Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5EEFA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Balance',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '\$ 50,000',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Align(
                        alignment: Alignment.topRight,
                         child: GestureDetector(
                             onTap: () {
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => const ActivityScreen()),
           );
           },
    child: Container(
      height: 30,
      width: 30,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add),
    ),
  ),
),
  
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Upcoming Payment
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming payment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  Text('See all', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildUpcomingCard(
                      color: Colors.indigo,
                      title: 'Car installments',
                      amount: '\$ 3000/month',
                      daysLeft: '2 days left',
                    ),
                    const SizedBox(width: 12),
                    _buildUpcomingCard(
                      color: Colors.grey[300]!,
                      title: 'Home Expenses',
                      amount: '\$ 3000/month',
                      daysLeft: '2 days left',
                      darkText: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent Payments
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent payments',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  Text('See all', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),

              // Payment List
              _buildTransactionTile('Amazon', '-\$50'),
              _buildTransactionTile('Supermarket', '-\$20'),
              _buildTransactionTile('Clothes', '-\$50'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingCard({
    required Color color,
    required String title,
    required String amount,
    required String daysLeft,
    bool darkText = false,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.search, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: darkText ? Colors.black : Colors.white,
              ),
            ),
            Text(
              amount,
              style: TextStyle(color: darkText ? Colors.black : Colors.white),
            ),
            Text(
              daysLeft,
              style: TextStyle(
                color: darkText ? Colors.black : Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(String title, String amount) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amazon'),
              Text(
                '21 Jan, 03:32 PM',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
