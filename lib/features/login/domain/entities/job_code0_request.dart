class JobCode0Request {
  final String username;
  final String password;
  final String position;
  final String district;

  JobCode0Request({
    required this.username,
    required this.password,
    required this.position,
    required this.district,
  });

  Map<String, dynamic> toJson() {
    return{
      "username" : username,
      "password" : password,
      "position" : position,
      "district" : district
    };
  }
}