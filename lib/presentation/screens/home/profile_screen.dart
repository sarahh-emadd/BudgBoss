import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'bottom_navigation_bar.dart';
import '../services/user_preferences_service.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;

  const ProfileScreen({super.key, this.userName = 'User'});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserPreferencesService _preferencesService = UserPreferencesService();
  User? _currentUser;
  bool _isLoading = true;
  bool _isSaving = false;
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  Map<String, dynamic> _userPreferences = {};

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _loadUserPreferences();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentUser() async {
    setState(() {
      _isLoading = true;
    });

    _currentUser = _auth.currentUser;
    if (_currentUser != null && _currentUser!.displayName != null) {
      _displayNameController.text = _currentUser!.displayName!;
    } else if (_currentUser != null && _currentUser!.email != null) {
      _displayNameController.text = _currentUser!.email!.split('@')[0];
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadUserPreferences() async {
    if (_currentUser != null) {
      try {
        final prefs = await _preferencesService.getUserPreferences(
          _currentUser!.uid,
        );
        setState(() {
          _userPreferences = prefs;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading preferences: $e')),
          );
        }
      }
    }
  }

  String _getDisplayName() {
    if (_currentUser != null) {
      if (_currentUser!.displayName != null &&
          _currentUser!.displayName!.isNotEmpty) {
        return _currentUser!.displayName!;
      } else if (_currentUser!.email != null) {
        // Use the part before @ in email as name if no display name
        return _currentUser!.email!.split('@')[0];
      }
    }
    return widget.userName;
  }

  String _getEmailAddress() {
    return _currentUser?.email ?? 'No email';
  }

  String _getInitial() {
    String displayName = _getDisplayName();
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null || _currentUser == null) return null;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profile_images')
          .child('${_currentUser!.uid}.jpg');

      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
      return null;
    }
  }

  Future<void> _updateProfile() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Profile'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile image picker
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        _imageFile != null
                            ? FileImage(_imageFile!) as ImageProvider
                            : (_currentUser?.photoURL != null
                                ? NetworkImage(_currentUser!.photoURL!)
                                    as ImageProvider
                                : null),
                    child:
                        _imageFile == null && _currentUser?.photoURL == null
                            ? Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.grey[700],
                            )
                            : null,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Tap to change profile photo',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                // Display name field
                TextFormField(
                  controller: _displayNameController,
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a display name';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  await _saveProfileChanges();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveProfileChanges() async {
    if (_currentUser == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Upload image if a new one was selected
      String? photoURL;
      if (_imageFile != null) {
        photoURL = await _uploadImage();
      }

      // Update profile
      await _currentUser!.updateDisplayName(_displayNameController.text);

      if (photoURL != null) {
        await _currentUser!.updatePhotoURL(photoURL);
      }

      // Refresh user data
      await _currentUser!.reload();
      setState(() {
        _currentUser = _auth.currentUser;
        _isSaving = false;
        _imageFile = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      }
    }
  }

  Future<void> _sendVerificationEmail() async {
    if (_currentUser == null) return;

    try {
      await _currentUser!.sendEmailVerification();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent. Please check your inbox.'),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending verification email: $e')),
      );
    }
  }

  Future<void> _deleteAccount() async {
    // Show confirmation dialog
    final bool confirmDelete =
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Account'),
              content: const Text(
                'Are you sure you want to delete your account? This action cannot be undone.',
                style: TextStyle(color: Colors.red),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmDelete) return;

    try {
      // Get current user data
      final User? user = _auth.currentUser;
      if (user == null) return;

      // Show re-authentication dialog
      final credential = await _requestReauthentication();
      if (credential == null) return;

      // Reauthenticate
      await user.reauthenticateWithCredential(credential);

      // Delete user data from Firestore
      await _preferencesService.deleteUserData(user.uid);

      // Delete the user account
      await user.delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully')),
        );
        Navigator.pushReplacementNamed(context, '/auth');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting account: $e')));
      }
    }
  }

  Future<AuthCredential?> _requestReauthentication() async {
    final TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<AuthCredential?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Re-authenticate'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate() &&
                    _currentUser?.email != null) {
                  final credential = EmailAuthProvider.credential(
                    email: _currentUser!.email!,
                    password: passwordController.text,
                  );
                  Navigator.pop(context, credential);
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    passwordController.dispose();
    return result;
  }

  Future<void> _updatePreferences(String key, dynamic value) async {
    if (_currentUser == null) return;

    try {
      await _preferencesService.updateUserPreference(
        _currentUser!.uid,
        key,
        value,
      );

      setState(() {
        _userPreferences[key] = value;
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text('Preference updated')));
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating preference: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3737CD),
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading || _isSaving
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3737CD),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Profile image
                          _currentUser?.photoURL != null
                              ? CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  _currentUser!.photoURL!,
                                ),
                              )
                              : CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: Text(
                                  _getInitial(),
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3737CD),
                                  ),
                                ),
                              ),
                          const SizedBox(height: 15),
                          // Username
                          Text(
                            _getDisplayName(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Email and verification status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _getEmailAddress(),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 5),
                              _currentUser != null &&
                                      _currentUser!.emailVerified
                                  ? const Icon(
                                    Icons.verified,
                                    color: Colors.green,
                                    size: 16,
                                  )
                                  : GestureDetector(
                                    onTap: _sendVerificationEmail,
                                    child: const Icon(
                                      Icons.error_outline,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                  ),
                            ],
                          ),
                          if (_currentUser != null &&
                              !_currentUser!.emailVerified)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: GestureDetector(
                                onTap: _sendVerificationEmail,
                                child: const Text(
                                  'Tap to verify email',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          // Edit profile button
                          ElevatedButton.icon(
                            onPressed: _updateProfile,
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit Profile'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF3737CD),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Account section
                    _buildSectionHeader('Account'),

                    _buildMenuItem(
                      context,
                      Icons.person_outline,
                      'Account Details',
                      'Change your account information',
                      _updateProfile,
                    ),

                    _buildMenuItem(
                      context,
                      Icons.lock_outline,
                      'Change Password',
                      'Update your password',
                      () {
                        if (_currentUser?.email != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Reset Password'),
                                content: Text(
                                  'Send password reset email to ${_currentUser!.email}?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      try {
                                        await FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                              email: _currentUser!.email!,
                                            );
                                        if (mounted) {
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(
                                            // ignore: use_build_context_synchronously
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Password reset email sent',
                                              ),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(
                                            // ignore: use_build_context_synchronously
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text('Error: $e'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: const Text('Send Email'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),

                    // App settings section
                    _buildSectionHeader('Settings'),

                    _buildSettingsMenuItem(
                      context,
                      Icons.dark_mode,
                      'Dark Mode',
                      'Toggle dark theme',
                      Switch(
                        value: _userPreferences['darkMode'] ?? false,
                        onChanged:
                            (value) => _updatePreferences('darkMode', value),
                        activeColor: const Color(0xFF3737CD),
                      ),
                    ),

                    _buildSettingsMenuItem(
                      context,
                      Icons.notifications,
                      'Notifications',
                      'Manage notification preferences',
                      Switch(
                        value: _userPreferences['notifications'] ?? true,
                        onChanged:
                            (value) =>
                                _updatePreferences('notifications', value),
                        activeColor: const Color(0xFF3737CD),
                      ),
                    ),

                    _buildMenuItem(
                      context,
                      Icons.bar_chart,
                      'Budget Goals',
                      'Set and track your financial goals',
                      () {
                        Navigator.pushNamed(context, '/goals');
                      },
                    ),

                    _buildMenuItem(
                      context,
                      Icons.security,
                      'Privacy & Security',
                      'Manage your data and security settings',
                      () {
                        Navigator.pushNamed(context, '/privacy');
                      },
                    ),

                    // Support section
                    _buildSectionHeader('Support'),

                    _buildMenuItem(
                      context,
                      Icons.help_outline,
                      'Help & Support',
                      'Get assistance with using Budget Boss',
                      () {
                        Navigator.pushNamed(context, '/help');
                      },
                    ),

                    _buildMenuItem(
                      context,
                      Icons.info_outline,
                      'About',
                      'App version and information',
                      () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Budget Boss',
                          applicationVersion: '1.0.0',
                          applicationIcon: const FlutterLogo(size: 40),
                          children: const [
                            Text(
                              'A simple and effective budget management app',
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Logout button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton.icon(
                        onPressed: _signOut,
                        icon: const Icon(Icons.logout),
                        label: const Text('Log Out'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[100],
                          foregroundColor: Colors.red[700],
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Delete account button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextButton(
                        onPressed: _deleteAccount,
                        child: const Text(
                          'Delete Account',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
      bottomNavigationBar: const BudgetBossNavBar(currentIndex: 3),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          leading: Container(
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
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildSettingsMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Widget trailing,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          leading: Container(
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
          trailing: trailing,
        ),
      ),
    );
  }
}
