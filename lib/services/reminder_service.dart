import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderService extends ChangeNotifier {
  ReminderService._();

  static final ReminderService instance = ReminderService._();

  static const String _remindersKey = 'reminders_enabled';

  bool _isEnabled = false;

  bool get isEnabled => _isEnabled;

  Future<void> loadReminderSetting() async {
    final preferences = await SharedPreferences.getInstance();

    _isEnabled = preferences.getBool(_remindersKey) ?? false;

    notifyListeners();
  }

  Future<void> setEnabled(bool value) async {
    _isEnabled = value;

    notifyListeners();

    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(
      _remindersKey,
      value,
    );
  }
}