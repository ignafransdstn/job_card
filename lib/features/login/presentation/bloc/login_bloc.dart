import 'package:bloc/bloc.dart';
import 'package:xml/xml.dart' as xml;
import '../../domain/entities/login_request.dart';
import '../../domain/usecase/login_usecase.dart';

class LoginState {
  final bool isLoading;
  final bool isSuccess;
  final String? username;
  final String? position; // Tambahkan untuk menyimpan position
  final String? password;
  final String? responseValue;
  final String? error;

  LoginState({
    this.isLoading = false,
    this.isSuccess = false,
    this.username,
    this.position,
    this.password,
    this.responseValue,
    this.error,
  });
}

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginState());

  Future<void> login(String username, String password,) async {
    emit(LoginState(isLoading: true));
    try {
      // Kirimkan request login ke API
      final response = await loginUseCase(LoginRequest(username: username, password: password));

      if (response.statusCode == 200) {
        // Parsing response SOAP XML menggunakan library 'xml'
        final document = xml.XmlDocument.parse(response.body);

        // Ambil position dari response
        final positionElement = document.findAllElements('ns1:name').single;
        final position = positionElement.text;

        // Emit state jika login berhasil
        emit(LoginState(
          isLoading: false,
          isSuccess: true,
          username: username,
          position: position,
          password: password,
          responseValue: 'Login successful',
        ));
      } else {
        emit(LoginState(
          isLoading: false,
          isSuccess: false,
          error: 'Login failed. Please check your credentials.',
        ));
      }
    } catch (e) {
      emit(LoginState(
        isLoading: false,
        error: 'An error occurred: $e',
      ));
    }
  }
}
