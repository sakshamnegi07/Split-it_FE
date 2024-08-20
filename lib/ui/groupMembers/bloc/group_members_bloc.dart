import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_fe/services/api_service.dart';
import 'group_members_event.dart';
import 'group_members_state.dart';

class GroupMembersBloc extends Bloc<GroupMembersEvent, GroupMembersState> {
  GroupMembersBloc() : super(GroupMembersInitial()) {
    on<FetchGroupMembers>(_onFetchGroupMembers);
    on<RemoveMember>(_onRemoveMember);
  }

  Future<void> _onFetchGroupMembers(FetchGroupMembers event, Emitter<GroupMembersState> emit) async {
    emit(GroupMembersLoading());
    try {
      final members = await ApiService.getGroupMembers(groupId: event.groupId);
      emit(GroupMembersLoaded(members));
    } catch (error) {
      emit(GroupMembersError('Failed to fetch group members: $error'));
    }
  }

  Future<void> _onRemoveMember(RemoveMember event, Emitter<GroupMembersState> emit) async {
    try {
      final result = await ApiService.removeMemberFromGroup(
        groupId: event.groupId,
        userId: event.userId,
      );
      if (result.containsKey('message')) {
        emit(MemberRemoved(result['message']));
        add(FetchGroupMembers(groupId: event.groupId)); // Refresh the group members
      } else {
        emit(GroupMembersError('Failed to remove member: ${result['error']}'));
      }
    } catch (error) {
      emit(GroupMembersError('Failed to remove member: $error'));
    }
  }
}
