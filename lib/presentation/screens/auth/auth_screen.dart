// lib/presentation/screens/auth/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/colors.dart';
import '../../../data/services/firebase_auth_service.dart';
import '../../../logging/budget_boss_logger.dart';

class FirebaseAuthScreen extends StatefulWidget {
  const FirebaseAuthScreen({super.key});

  @override
  State<FirebaseAuthScreen> createState() => _FirebaseAuthScreenState();
}

class _FirebaseAuthScreenState extends State<FirebaseAuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();
  final BudgetBossLogger _logger = BudgetBossLogger();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _logger.log('FirebaseAuthScreen initialized');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryColor,
              indicatorWeight: 3,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [Tab(text: 'Login'), Tab(text: 'Sign Up')],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildLoginTab(), _buildSignUpTab()],
      ),
    );
  }

  Widget _buildLoginTab() => _buildAuthTab(isLogin: true);
  Widget _buildSignUpTab() => _buildAuthTab(isLogin: false);

  Widget _buildAuthTab({required bool isLogin}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              isLogin
                  ? 'assets/images/icons/undraw_secure-login_m11a__1_-removebg-preview.png'
                  : 'assets/images/icons/undraw_young-man-avatar_wgbd-removebg-preview.png',
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                _logger.error('Image load error', error, stackTrace);
                return Icon(
                  isLogin ? Icons.security : Icons.person_add,
                  size: 100,
                  color: AppColors.primaryColor,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isLogin ? 'Welcome Back' : 'Create an Account',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isLogin
                ? 'Sign in to continue to Budget Boss'
                : 'Join Budget Boss and take control of your finances',
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red.shade800),
              ),
            ),

          if (!isLogin) ...[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Mobile Number'),
            ),
            const SizedBox(height: 16),
          ],

          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed:
                    () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
              ),
            ),
          ),

          if (isLogin)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _isLoading ? null : _handleForgotPassword,
                child: const Text('Forgot Password?'),
              ),
            ),

          if (!isLogin) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed:
                      () => setState(
                        () =>
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _acceptTerms,
                  onChanged:
                      (value) => setState(() => _acceptTerms = value ?? false),
                ),
                const Expanded(
                  child: Text('I accept the Terms and Conditions'),
                ),
              ],
            ),
          ],

          const SizedBox(height: 24),
          ElevatedButton(
            onPressed:
                _isLoading ? null : (isLogin ? _handleLogin : _handleRegister),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                _isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      isLogin ? 'Login' : 'Sign Up',
                      style: const TextStyle(fontSize: 16),
                    ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      _logger.log('Login successful');

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
      _logger.error('Login error: ${e.code}', e);
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
      _logger.error('Login unexpected error', e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleRegister() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }
    if (_passwordController.text.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters');
      return;
    }
    if (!_acceptTerms) {
      setState(() => _errorMessage = 'Please accept the Terms & Conditions');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      _logger.log('Registration successful');

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
      _logger.error('Registration error: ${e.code}', e);
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
      _logger.error('Registration unexpected error', e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    if (_emailController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email address');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent! Check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );
      }

      _logger.log('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
      _logger.error('Password reset error: ${e.code}', e);
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
      _logger.error('Password reset unexpected error', e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
