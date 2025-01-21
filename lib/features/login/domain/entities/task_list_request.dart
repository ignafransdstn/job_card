class WoTaskRequest {
  final String username;
  final String password;
  final String position;
  final String district;
  final String workOrder;
  final String districtCode;

  WoTaskRequest({
    required this.username,
    required this.password,
    required this.position,
    required this.district,
    required this.workOrder,
    required this.districtCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "username" : username,
      "password" : password,
      "position" : position,
      "district" : district,
      "workOrder" : workOrder,
      "districtCode" : districtCode
    };
  }
}
