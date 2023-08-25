import 'package:phone_number/phone_number.dart';

class PhoneUtil {
  /// Parse phone
  static Future<PhoneNumber> parsePhone({
    required String phone,
  }) async {
    RegionInfo region = const RegionInfo(code: 'VN', name: 'vi', prefix: 84);
    PhoneNumber phoneNumber =
        await PhoneNumberUtil().parse(phone, regionCode: region.code);
    return phoneNumber;
  }

  /// Validate phone
  static Future<bool> validatePhone({
    required String phone,
  }) async {
    RegionInfo region = const RegionInfo(code: 'VN', name: 'vi', prefix: 84);
    return PhoneNumberUtil().validate(phone, regionCode: region.code);
  }

  /// Is Validate
  Future<bool> isValidate({
    required String phone,
  }) async {
    return PhoneNumberUtil().validate(phone, regionCode: 'VN');
  }
}
