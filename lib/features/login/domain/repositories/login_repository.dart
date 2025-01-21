import 'package:http/http.dart' as http;
import '../../domain/entities/login_request.dart';

abstract class LoginRepository {
  Future<http.Response> login(LoginRequest request);
}
