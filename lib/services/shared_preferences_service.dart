import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<int?> getTotalEvents() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int? _localTotalEventNumber = _prefs.getInt('totalEvents');
    return _localTotalEventNumber;
  }

  Future<void> saveTotalEvents(int totalEventsNumber) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('totalEvents', totalEventsNumber);
    print('totalEvents saved $totalEventsNumber');
  }

  Future<void> saveUserRole(String role) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('userRole', role);
  }

  Future<String?> getUserRole() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.getString("userRole");
  }
}
