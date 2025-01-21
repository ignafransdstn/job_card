class JobSearchRequest {
  final String username;
  final String password;
  final String position;
  final String district;
  final String workOrder;
  final String originatorId;
  final String workOrderSearchMethod;
  final String woStatusM;

  JobSearchRequest({
    required this.username,
    required this.password,
    required this.position,
    required this.district,
    required this.workOrder,
    required this.originatorId,
    required this.workOrderSearchMethod,
    required this.woStatusM
  });

  Map<String, dynamic> toJson() {
    return {
      "username" : username,
      "password" : password,
      "position" : position,
      "district" : district,
      "workOrder": workOrder,
      "originatorId" : originatorId,
      "workOrderSearchMethod" : workOrderSearchMethod,
      "woStatusM" : woStatusM
    };
  }
}