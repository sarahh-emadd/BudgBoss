// lib/presentation/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import '../../../logging/budget_boss_logger.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Welcome to Your\nBudget Boss',
      'subtitle': '',
      'description': '',
      'image':
          'assets/images/icons/undraw_digital-currency_u5p6-removebg-preview-1.png',
      'backgroundColor': const Color(0xFF3737CD),
      'textColor': Colors.white,
    },
    {
      'title': 'Take Control of Your Money',
      'subtitle': 'Master your money',
      'description': '',
      'image':
          'assets/images/icons/undraw_crypto-portfolio_cat6-removebg-preview.png',
      'backgroundColor': const Color(0xFF3737CD),
      'textColor': Colors.white,
    },
    {
      'title': 'Track Smarter, Spend Better.',
      'subtitle': 'Track, analyze, and decide better.',
      'description': 'Track, analyze, and decide better.',
      'image':
          'assets/images/icons/undraw_visual-data_3ghp-removebg-preview.png',
      'backgroundColor': const Color(0xFF3737CD),
      'textColor': Colors.white,
    },
    {
      'title': 'One Wallet. Multiple Minds. Total Clarity',
      'subtitle': 'Co-manage wallets for work, projects, or\nfamily.',
      'description': 'Co-manage wallets for work, projects, or\nfamily.',
      'image':
          'assets/images/icons/undraw_data-points_1q5h-removebg-preview.png',
      'backgroundColor': const Color(0xFF3737CD),
      'textColor': Colors.white,
    },
    {
      'title': 'One Wallet. Multiple Minds. Total Clarity',
      'subtitle': 'Lets Start Now!',
      'description': 'Lets Start Now!',
      'image':
          'assets/images/icons/undraw_going-offline_v4oo-removebg-preview-1.png',
      'backgroundColor': const Color(0xFF3737CD),
      'textColor': Colors.white,
    },
  ];

  @override
  void initState() {
    super.initState();
    BudgetBossLogger.log('OnboardingScreen initialized');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // New method to navigate to auth screen
  void _navigateToAuth() {
    BudgetBossLogger.log('Navigating to Auth Screen');
    Navigator.pushReplacementNamed(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with curved bottom
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Top blue curved background
                    ClipPath(
                      clipper: CurvedBottomClipper(),
                      child: Container(
                        color: _onboardingData[index]['backgroundColor'],
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          top: 60,
                          left: 20,
                          right: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _onboardingData[index]['title'],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _onboardingData[index]['textColor'],
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Main image
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Image.asset(
                          _onboardingData[index]['image'],
                          height: MediaQuery.of(context).size.height * 0.25,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            BudgetBossLogger.error(
                              'Image loading error',
                              error,
                              stackTrace,
                            );
                            return const Icon(Icons.broken_image, size: 100);
                          },
                        ),
                      ),
                    ),

                    // Subtitle
                    if ((_onboardingData[index]['subtitle'] ?? '').isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          _onboardingData[index]['subtitle'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                    const SizedBox(height: 40),

                    // Bottom indicators and line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardingData.length,
                        (dotIndex) => buildDot(dotIndex),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 60,
                        height: 5,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 80), // adds space above button
                  ],
                ),
              );
            },
          ),

          // Next/Get Started button
          Positioned(
            bottom: 40,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage == _onboardingData.length - 1) {
                  // This is the key change: navigate to auth screen instead of home
                  _navigateToAuth();
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3737CD),
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              child: Icon(
                _currentPage == _onboardingData.length - 1
                    ? Icons.check
                    : Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ),

          // Skip button - Added to allow skipping directly to auth
          Positioned(
            bottom: 40,
            left: 20,
            child: TextButton(
              onPressed: _navigateToAuth,
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 79, 74, 114),
              ),
              child: const Text(
                'Skip',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: _currentPage == index ? 25 : 10,
      decoration: BoxDecoration(
        color:
            _currentPage == index ? const Color(0xFF3737CD) : Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

// Custom clipper for curved bottom edge
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 80);

    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height - 40);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 3 / 4, size.height - 80);
    final secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
