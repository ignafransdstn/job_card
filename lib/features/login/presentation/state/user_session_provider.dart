import 'package:flutter/foundation.dart';

class UserSession extends ChangeNotifier {
  String? _username;
  String? _password;
  String? _position;
  String? _workOrder;
  String? _district; // Tambahkan districtCode
  String? _districtCode;

  // Getter untuk username
  String? get username => _username;

  // Getter untuk password
  String? get password => _password;

  // Getter untuk position
  String? get position => _position;

  // Getter untu workOrder no
  String? get workOrder => _workOrder;

  String? get district => _district;

  String? get districtCode => _districtCode;

  // Method untuk menyimpan data login
  void setUserDetails(
      {required String username,
      required String password,
      required String position}) {
    _username = username;
    _password = password;
    _position = position;
    notifyListeners(); // Beritahu listener untuk refresh UI
  }

  // Method untuk menyimpan workOrder
  void setWorkOrder(String workOrder) {
    _workOrder = workOrder;
    notifyListeners();
  }

  void setDistrictCode(String districtCode) {
  _districtCode = districtCode; // Perbaiki dari _district ke _districtCode
  notifyListeners();
}

  void setDistrict(String district) {
    _district = district;
    notifyListeners();
  }
}
