import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart'; // Tambahkan ini
import '../bloc/login_bloc.dart';
import '../state/user_session_provider.dart'; // Import UserSession

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/image.png', // logo
                  height: 150,
                ),
                const SizedBox(height: 20),

                // Username Input
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    hintText: 'Type here',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Password Input
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state.isSuccess) {
                        // Simpan data login ke dalam UserSession
                        final userSession =
                            Provider.of<UserSession>(context, listen: false);
                        userSession.setUserDetails(
                          username: _usernameController.text,
                          password: _passwordController.text,
                          position:
                              state.position ?? '', // Ambil position dari state
                        );

                        // Pindah ke halaman NextPage jika login berhasil
                        Navigator.pushNamed(context, '/nextPage', arguments: {
                          'responseValue': state.responseValue ?? '',
                          'username': state.username ?? '',
                          'password': state.password ?? '',
                          'position': state.position ?? '',
                        });
                      } else if (state.error != null) {
                        // Tampilkan dialog error jika login gagal
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Login Failed'),
                            content: Text(state.error!),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const CircularProgressIndicator();
                      }

                      return ElevatedButton(
                        onPressed: () {
                          // Panggil login cubit
                          context.read<LoginCubit>().login(
                                _usernameController.text,
                                _passwordController.text,
                              );

                          final userSession =
                              Provider.of<UserSession>(context, listen: false);
                          userSession.setUserDetails(
                            username: _usernameController.text,
                            password: _passwordController.text,
                            position: '',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: const Color(0xFFE65C4F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
