abstract class RegisterEvent {}

class RegisterButtonPressed extends RegisterEvent {
  final String username;
  final String email;
  final String password;

  RegisterButtonPressed({
    required this.username,
    required this.email,
    required this.password,
  });
}
