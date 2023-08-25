import 'package:shared_preferences/shared_preferences.dart';

import '../models/user/customer_info.dart';

class AppPreference {
  /// Save customer info
  Future<void> saveCustomerInfo({
    required CustomerInfo customerInfo,
  }) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(AppPreferenceKey.kCustomerInfo, customerInfo.toRawJson());
  }

  /// Get user
  Future<CustomerInfo?> getCustomerInfo() async {
    final pref = await SharedPreferences.getInstance();
    final jsonStr = pref.getString(AppPreferenceKey.kCustomerInfo);
    if (jsonStr == null || jsonStr.isEmpty) {
      return null;
    }
    return CustomerInfo.fromRawJson(jsonStr);
  }
}

class AppPreferenceKey {
  static const String kUser = 'user';
  static const String kCustomerInfo = 'customer_info';
  static const String kFirstRun = 'first_run';
}
