import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../../../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final response = await ApiService.login(
        email: event.email,
        password: event.password,
      );

      if (response['token'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', response['userId']);
        await prefs.setString('userName', response['username']);
        await prefs.setString('authToken', response['token']);
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(error: response['error'] ?? 'Login failed'));
      }
    } catch (error) {
      emit(LoginFailure(error: "Network error!"));
    }
  }
}
