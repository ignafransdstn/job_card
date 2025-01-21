import '../../domain/repositories/login_repository.dart';
import '../../domain/entities/login_request.dart';
import 'package:http/http.dart' as http;

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<http.Response> call(LoginRequest request) async {
    // Panggil method login dari repository
    return await repository.login(request);
  }
}
