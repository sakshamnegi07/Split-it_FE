import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_fe/utils/toast.dart';
import 'package:split_fe/services/api_service.dart';
import 'package:split_fe/dialogs/addMemberDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/group_members_bloc.dart';
import 'bloc/group_members_event.dart';
import 'bloc/group_members_state.dart';

class GroupMembersScreen extends StatefulWidget {
  final String groupName;
  final String groupDescription;
  final int groupId;
  final bool isAdmin;

  GroupMembersScreen(
      {required this.groupName,
      required this.groupDescription,
      required this.groupId,
      required this.isAdmin});

  @override
  _GroupMembersScreenState createState() => _GroupMembersScreenState();
}

class _GroupMembersScreenState extends State<GroupMembersScreen> {
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    context
        .read<GroupMembersBloc>()
        .add(FetchGroupMembers(groupId: widget.groupId));
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getInt('userId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.groupName} members",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ]),
        ),
      ),
      body: BlocBuilder<GroupMembersBloc, GroupMembersState>(
        builder: (context, state) {
          if (state is GroupMembersLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GroupMembersError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is GroupMembersLoaded) {
            if (state.groupMembers.isEmpty) {
              return Center(child: Text('No members found'));
            }
            return Padding(
              padding:
                  const EdgeInsets.only(top: 15.0), // Add padding at the top
              child: ListView.builder(
                itemCount: state.groupMembers.length,
                itemBuilder: (context, index) {
                  final user = state.groupMembers[index];
                  final isCurrentUser = user['id'] == currentUserId;
                  return GroupMembersCard(
                    user: user,
                    isCurrentUser: isCurrentUser,
                    isBalancePositive: user['amount'] >= 0,
                    isGroupAdmin: widget.isAdmin,
                    groupId: widget.groupId,
                    refreshGroupMembers: () {
                      context
                          .read<GroupMembersBloc>()
                          .add(FetchGroupMembers(groupId: widget.groupId));
                    },
                  );
                },
              ),
            );
          }
          return Center(child: Text('No members found'));
        },
      ),
    );
  }
}

class GroupMembersCard extends StatelessWidget {
  final dynamic user;
  final bool isCurrentUser;
  final bool isBalancePositive;
  final bool isGroupAdmin;
  final int groupId;
  final VoidCallback refreshGroupMembers;

  GroupMembersCard(
      {required this.user,
      required this.isCurrentUser,
      required this.isBalancePositive,
      required this.isGroupAdmin,
      required this.groupId,
      required this.refreshGroupMembers});

  void onSelected(BuildContext context, int item) async {
    switch (item) {
      case 0:
        if (!isGroupAdmin)
          ToastService.showToast(
              "Only admin is allowed to remove members from group!");
        else {
          context
              .read<GroupMembersBloc>()
              .add(RemoveMember(groupId: groupId, userId: user['id']));
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            children: [
              Icon(Icons.person_2_outlined, color: Colors.grey[300], size: 35),
              SizedBox(width: 4),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isCurrentUser
                          ? '${user['username']} (YOU)'
                          : user['username'],
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        if (!isCurrentUser)
                          Column(
                            children: [
                              Text(
                                isBalancePositive ? 'You are owed' : 'You owe',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: isBalancePositive
                                        ? Colors.green[500]
                                        : Colors.red[300]),
                              ),
                              Text(
                                'Rs. ${user['amount']}',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isBalancePositive
                                        ? Colors.green[500]
                                        : Colors.red[300]),
                              ),
                            ],
                          ),
                        SizedBox(width: 2),
                        if (!isCurrentUser)
                          PopupMenuButton<int>(
                            color: Colors.grey[500],
                            icon: Icon(Icons.more_vert, color: Colors.white70),
                            onSelected: (item) => onSelected(context, item),
                            itemBuilder: (context) => [
                              PopupMenuItem<int>(
                                value: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[500],
                                  ),
                                  child: Text(
                                    'Remove from group!',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      color: Colors.grey[800],
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }
}
