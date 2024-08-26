import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_fe/utils/toast.dart';
import 'package:split_fe/services/api_service.dart';
import 'package:split_fe/dialogs/addMemberDialog.dart';
import 'package:split_fe/dialogs/addExpenseDialog/add_expense.dart';
import 'package:split_fe/ui/groupMembers/groupMembers.dart';
import 'bloc/group_details_bloc.dart';
import 'bloc/group_details_event.dart';
import 'bloc/group_details_state.dart';
import 'package:split_fe/ui/groupMembers/bloc/group_members_bloc.dart';
import 'package:split_fe/ui/groupMembers/bloc/group_members_event.dart';
import 'package:split_fe/widgets/group_expenses_card.dart';

class GroupDetailsScreen extends StatefulWidget {
  final String groupName;
  final String groupDescription;
  final int groupId;
  final bool isAdmin;

  GroupDetailsScreen(
      {required this.groupName,
      required this.groupDescription,
      required this.groupId,
      required this.isAdmin});

  @override
  _GroupDetailsScreenState createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<GroupDetailsBloc>()
        .add(FetchGroupDetails(groupId: widget.groupId));
  }

  Future<void> _openExpenseDialog() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddExpenseDialog(groupId: widget.groupId);
      },
    );

    if (result != null) {
      await Future.delayed(Duration(milliseconds: 500));
      context
          .read<GroupDetailsBloc>()
          .add(FetchGroupDetails(groupId: widget.groupId));
    }
  }

  Future<void> _openAddMemberDialog() async {
    if (!widget.isAdmin) {
      ToastService.showToast("Only admin is allowed to add members!");
      return;
    }
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return UserSearchDialog(groupId: widget.groupId);
      },
    );

    if (result != null) {
      context
          .read<GroupDetailsBloc>()
          .add(FetchGroupDetails(groupId: widget.groupId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.groupName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold)),
                  if (widget.groupDescription != "")
                    Text(widget.groupDescription,
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.people,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => GroupMembersBloc()
                      ..add(FetchGroupMembers(groupId: widget.groupId)),
                    child: GroupMembersScreen(
                        groupName: widget.groupName,
                        groupDescription: widget.groupDescription,
                        groupId: widget.groupId,
                        isAdmin: widget.isAdmin),
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Colors.grey[600], // Custom background color
                  ),
                  onPressed: () => _openAddMemberDialog(),
                  child: Text('Add Member'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Colors.grey[600], // Custom background color
                  ),
                  onPressed: () => _openExpenseDialog(),
                  child: Text('Add Expense'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
              builder: (context, state) {
                if (state is GroupDetailsLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is GroupDetailsError) {
                  return Center(child: Text('Error: ${state.error}'));
                } else if (state is GroupDetailsLoaded) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 15.0),
                      child: Column(
                        children: [
                          Text(
                            'Overall Balance',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: state.overallGroupBalance >= 0.0
                                  ? Colors.green[400]
                                  : Colors.orange[800],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            state.overallGroupBalance >= 0.0
                                ? 'You are owed Rs. ${state.overallGroupBalance}'
                                : 'You owe Rs. ${state.overallGroupBalance.abs()}',
                            style: TextStyle(
                              fontSize: 16,
                              color: state.overallGroupBalance >= 0.0
                                  ? Colors.green[400]
                                  : Colors.orange[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    color: Colors.grey[850],
                  );
                } else {
                  return Center(child: Text('No balance data'));
                }
              },
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
                builder: (context, state) {
                  if (state is GroupDetailsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is GroupDetailsError) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else if (state is GroupDetailsLoaded) {
                    return ListView.builder(
                      itemCount: state.groupExpenses.length,
                      itemBuilder: (context, index) {
                        return GroupExpensesCard(
                            expense: state.groupExpenses[index]);
                      },
                    );
                  }
                  return Center(child: Text('No data available'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
