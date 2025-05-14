import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_preferences_service.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserPreferencesService _preferencesService = UserPreferencesService();
  bool _isLoading = true;
  Map<String, dynamic> _privacySettings = {};

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userData = await _preferencesService.getUserPreferences(user.uid);

        // Extract privacy settings
        final preferences =
            userData['preferences'] as Map<String, dynamic>? ?? {};
        setState(() {
          _privacySettings = {
            'dataCollection': preferences['dataCollection'] ?? true,
            'analyticsSharing': preferences['analyticsSharing'] ?? false,
            'twoFactorAuth': preferences['twoFactorAuth'] ?? false,
            'biometricLogin': preferences['biometricLogin'] ?? false,
            'autoLogout': preferences['autoLogout'] ?? true,
            'autoLogoutDuration':
                preferences['autoLogoutDuration'] ?? 30, // minutes
          };
        });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading privacy settings: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updatePrivacySetting(String key, dynamic value) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _preferencesService.updateUserPreference(user.uid, key, value);
        setState(() {
          _privacySettings[key] = value;
        });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating setting: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3737CD),
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Security settings
                    _buildSectionHeader(context, 'Security Settings'),

                    _buildToggleSetting(
                      icon: Icons.lock_outline,
                      title: 'Two-Factor Authentication',
                      subtitle: 'Add an extra layer of security',
                      value: _privacySettings['twoFactorAuth'] ?? false,
                      onChanged:
                          (value) =>
                              _updatePrivacySetting('twoFactorAuth', value),
                    ),

                    _buildToggleSetting(
                      icon: Icons.fingerprint,
                      title: 'Biometric Login',
                      subtitle: 'Use fingerprint or face recognition',
                      value: _privacySettings['biometricLogin'] ?? false,
                      onChanged:
                          (value) =>
                              _updatePrivacySetting('biometricLogin', value),
                    ),

                    _buildToggleSetting(
                      icon: Icons.timer_outlined,
                      title: 'Auto Logout',
                      subtitle: 'Automatically logout after inactivity',
                      value: _privacySettings['autoLogout'] ?? true,
                      onChanged:
                          (value) => _updatePrivacySetting('autoLogout', value),
                    ),

                    if (_privacySettings['autoLogout'] ?? true)
                      _buildSliderSetting(
                        icon: Icons.access_time,
                        title: 'Auto Logout Duration',
                        subtitle:
                            '${_privacySettings['autoLogoutDuration']} minutes',
                        value:
                            (_privacySettings['autoLogoutDuration'] ?? 30)
                                .toDouble(),
                        min: 1,
                        max: 60,
                        onChanged: (value) {
                          setState(() {
                            _privacySettings['autoLogoutDuration'] =
                                value.round();
                          });
                        },
                        onChangeEnd: (value) {
                          _updatePrivacySetting(
                            'autoLogoutDuration',
                            value.round(),
                          );
                        },
                      ),

                    // Privacy settings
                    _buildSectionHeader(context, 'Privacy Settings'),

                    _buildToggleSetting(
                      icon: Icons.analytics_outlined,
                      title: 'Data Collection',
                      subtitle: 'Allow app to collect usage data',
                      value: _privacySettings['dataCollection'] ?? true,
                      onChanged:
                          (value) =>
                              _updatePrivacySetting('dataCollection', value),
                    ),

                    _buildToggleSetting(
                      icon: Icons.share_outlined,
                      title: 'Analytics Sharing',
                      subtitle: 'Share anonymous usage data',
                      value: _privacySettings['analyticsSharing'] ?? false,
                      onChanged:
                          (value) =>
                              _updatePrivacySetting('analyticsSharing', value),
                    ),

                    // Data management
                    _buildSectionHeader(context, 'Data Management'),

                    _buildActionCard(
                      icon: Icons.cloud_download_outlined,
                      title: 'Export Data',
                      subtitle: 'Download all your data as CSV',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Export feature coming soon!'),
                          ),
                        );
                      },
                    ),

                    _buildActionCard(
                      icon: Icons.delete_outline,
                      title: 'Clear App Data',
                      subtitle: 'Delete cached data from device',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Clear App Data'),
                              content: const Text(
                                'This will clear locally stored data from your device. '
                                'Your account data on our servers will not be affected.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Local data cleared'),
                                      ),
                                    );
                                  },
                                  child: const Text('Clear Data'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Privacy policy
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            // Show privacy policy
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Privacy Policy'),
                                  content: const SingleChildScrollView(
                                    child: Text(
                                      'Budget Boss Privacy Policy\n\n'
                                      'This privacy policy describes how we collect, use, and share '
                                      'your personal information when you use our Budget Boss app.\n\n'
                                      'Information We Collect:\n'
                                      '• Personal information you provide (email, name)\n'
                                      '• Financial information you enter (expenses, income)\n'
                                      '• Usage data (how you interact with the app)\n\n'
                                      'How We Use Your Information:\n'
                                      '• To provide and improve our services\n'
                                      '• To personalize your experience\n'
                                      '• To communicate with you\n\n'
                                      'Data Security:\n'
                                      'We implement appropriate security measures to protect your personal information.\n\n'
                                      'Third-Party Services:\n'
                                      'We may use third-party services such as Firebase for authentication '
                                      'and data storage, which have their own privacy policies.\n\n'
                                      'Changes to This Policy:\n'
                                      'We may update this privacy policy from time to time. '
                                      'We will notify you of any changes by posting the new privacy policy on this page.',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            'View Privacy Policy',
                            style: TextStyle(
                              color: Color(0xFF3737CD),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildToggleSetting({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SwitchListTile(
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF3737CD).withValues(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF3737CD)),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF3737CD),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderSetting({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required ValueChanged<double> onChangeEnd,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3737CD).withValues(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: const Color(0xFF3737CD)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Slider(
                value: value,
                min: min,
                max: max,
                divisions: max.toInt(),
                label: value.round().toString(),
                onChanged: onChanged,
                onChangeEnd: onChangeEnd,
                activeColor: const Color(0xFF3737CD),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${min.toInt()} min',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  Text(
                    '${max.toInt()} min',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3737CD).withValues(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFF3737CD)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
