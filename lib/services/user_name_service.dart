import 'package:shared_preferences/shared_preferences.dart';

class UserNameService {
  static const String _nameKey = 'user_name';

  static Future<String?> getName() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_nameKey);
  }

  static Future<void> saveName(String name) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_nameKey, name);
  }
}