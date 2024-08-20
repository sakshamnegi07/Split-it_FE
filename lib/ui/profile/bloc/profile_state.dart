abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> userDetails;

  ProfileLoaded(this.userDetails);
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);
}