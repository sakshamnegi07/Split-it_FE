import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_fe/services/api_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<FetchUserDetails>(_onFetchUserDetails);
  }

  Future<void> _onFetchUserDetails(FetchUserDetails event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final userDetails = await ApiService.getUserDetails();
      emit(ProfileLoaded(userDetails));
    } catch (error) {
      emit(ProfileError('Failed to fetch user details: $error'));
    }
  }
}
