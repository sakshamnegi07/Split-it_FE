import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_fe/ui/home/home.dart';
import 'package:split_fe/utils/toast.dart';
import 'package:split_fe/services/api_service.dart';
import 'package:split_fe/widgets/text_field.dart';
import 'package:split_fe/models/user.dart';
import 'package:split_fe/ui/login/login.dart';
import 'bloc/register_bloc.dart';
import 'bloc/register_event.dart';
import 'bloc/register_state.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isValidEmail(String email) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0, top: 3.0),
                child: Image.asset('assets/images/logo.png',
                    width: 30, height: 30),
              ),
              const Text('Split-it',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => RegisterBloc(),
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ToastService.showToast('Registration successful, you can login now!');
              Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            } else if (state is RegisterFailure) {
              ToastService.showToast('Registration failed: ${state.error}');
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _usernameController,
                        hintText: 'Your name',
                      ),
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email',
                      ),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 50), // Add some space before the buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 45,
                            width: 150,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                  color: Colors.grey,
                                ),
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(5)),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => HomeScreen()));
                              },
                              child: const Text(
                                'Back',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 40), // Spacing between the buttons
                          Container(
                            height: 45,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5)),
                            child: TextButton(
                              onPressed: () {
                                if (_usernameController.text.isEmpty ||
                                    _emailController.text.isEmpty ||
                                    _passwordController.text.isEmpty) {
                                  ToastService.showToast('Enter all the values');
                                  return;
                                }

                                if (!_isValidEmail(_emailController.text)) {
                                  ToastService.showToast("Invalid Email");
                                  return;
                                }

                                if (_passwordController.text.length < 8) {
                                  ToastService.showToast("Minimum length of password must be 8");
                                  return;
                                }

                                context.read<RegisterBloc>().add(
                                  RegisterButtonPressed(
                                    username: _usernameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              },
                              child: const Text(
                                'Done',
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (state is RegisterLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
