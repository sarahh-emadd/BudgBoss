import 'package:cloud_firestore/cloud_firestore.dart';

class UserPreferencesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a reference to the user's preferences document
  DocumentReference _getUserDoc(String userId) {
    return _firestore.collection('users').doc(userId);
  }

  // Get user preferences
  Future<Map<String, dynamic>> getUserPreferences(String userId) async {
    try {
      final docSnapshot = await _getUserDoc(userId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;

        // Get the preferences sub-collection if it exists
        final prefsSnapshot =
            await _getUserDoc(
              userId,
            ).collection('preferences').doc('userPrefs').get();

        if (prefsSnapshot.exists) {
          final prefsData = prefsSnapshot.data() as Map<String, dynamic>;
          data['preferences'] = prefsData;
        } else {
          // Initialize default preferences
          final defaultPrefs = _getDefaultPreferences();
          await _getUserDoc(
            userId,
          ).collection('preferences').doc('userPrefs').set(defaultPrefs);
          data['preferences'] = defaultPrefs;
        }

        return data;
      } else {
        // Initialize user document with default data
        final defaultData = {
          'userId': userId,
          'createdAt': FieldValue.serverTimestamp(),
          'lastActive': FieldValue.serverTimestamp(),
        };

        await _getUserDoc(userId).set(defaultData);

        // Initialize default preferences
        final defaultPrefs = _getDefaultPreferences();
        await _getUserDoc(
          userId,
        ).collection('preferences').doc('userPrefs').set(defaultPrefs);

        return {...defaultData, 'preferences': defaultPrefs};
      }
    } catch (e) {
      // Return default preferences on error
      return {'preferences': _getDefaultPreferences(), 'error': e.toString()};
    }
  }

  // Update a specific user preference
  Future<void> updateUserPreference(
    String userId,
    String key,
    dynamic value,
  ) async {
    await _getUserDoc(userId).collection('preferences').doc('userPrefs').set({
      key: value,
    }, SetOptions(merge: true));

    // Update last active timestamp
    await _getUserDoc(
      userId,
    ).update({'lastActive': FieldValue.serverTimestamp()});
  }

  // Update multiple user preferences at once
  Future<void> updateUserPreferences(
    String userId,
    Map<String, dynamic> preferences,
  ) async {
    await _getUserDoc(userId)
        .collection('preferences')
        .doc('userPrefs')
        .set(preferences, SetOptions(merge: true));

    // Update last active timestamp
    await _getUserDoc(
      userId,
    ).update({'lastActive': FieldValue.serverTimestamp()});
  }

  // Delete user data (for account deletion)
  Future<void> deleteUserData(String userId) async {
    // Delete preferences subcollection
    final prefsSnapshot =
        await _getUserDoc(userId).collection('preferences').get();

    for (var doc in prefsSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete other subcollections if they exist
    final expensesSnapshot =
        await _getUserDoc(userId).collection('expenses').get();

    for (var doc in expensesSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete the user document itself
    await _getUserDoc(userId).delete();
  }

  // Default preferences
  Map<String, dynamic> _getDefaultPreferences() {
    return {
      'darkMode': false,
      'notifications': true,
      'currency': 'USD',
      'budgetAlerts': true,
      'weeklyReports': true,
      'monthStartDay': 1, // 1st day of month
      'categories': [
        'Food',
        'Transportation',
        'Housing',
        'Entertainment',
        'Shopping',
        'Utilities',
        'Health',
        'Education',
        'Other',
      ],
    };
  }
}
