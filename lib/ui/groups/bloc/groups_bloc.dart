import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_fe/services/api_service.dart';
import 'groups_event.dart';
import 'groups_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc() : super(GroupInitial()) {
    on<FetchGroups>(_onFetchGroups);
    on<CreateGroup>(_onCreateGroup);
  }

  Future<void> _onFetchGroups(FetchGroups event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    try {
      final groups = await ApiService.getGroupsByUserId();
      emit(GroupsLoaded(groups));
    } catch (error) {
      emit(GroupError('Failed to fetch groups: $error'));
    }
  }

  Future<void> _onCreateGroup(CreateGroup event, Emitter<GroupState> emit) async {
    try {
      final response = await ApiService.createGroup(
        groupName: event.groupName,
        groupDesc: event.groupDescription,
      );

      if (response != null) {
        emit(GroupCreated());
        add(FetchGroups());  // Fetch the updated list of groups
      } else {
        emit(GroupError('Failed to create group'));
      }
    } catch (error) {
      emit(GroupError('Failed to create group: $error'));
    }
  }
}
