import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../domain/entities/login_request.dart';
import '../../domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final http.Client client;

  LoginRepositoryImpl(this.client);

  @override
  Future<http.Response> login(LoginRequest request) async {
    final response = await client.post(
      Uri.parse('http://10.70.0.44:5229/api/Positions'),  // URL API http://10.70.0.41:5229/api/Positions
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': request.username,
        'password': request.password,
      }),
    );
    return response;
  }
}
