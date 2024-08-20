abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoginFailure) return false;
    return other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
