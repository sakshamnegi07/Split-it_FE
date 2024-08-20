import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'package:split_fe/ui/groupDetails/groupDetails.dart';
import 'package:split_fe/ui/groupDetails/bloc/group_details_bloc.dart';
import 'package:split_fe/ui/groupDetails/bloc/group_details_event.dart';

class GroupCard extends StatelessWidget {
  final random = Random();
  final dynamic group;
  final bool isAdmin;

  GroupCard({required this.group, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                  create: (context) => GroupDetailsBloc()..add(FetchGroupDetails(groupId: group['group_id'])),
                  child: GroupDetailsScreen(
                      groupName: group['group_name'],
                      groupDescription: group['group_description'],
                      groupId: group['group_id'],
                      isAdmin: isAdmin)),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(Icons.group,
                  color: Color.fromARGB(
                    255,
                    random.nextInt(256),
                    random.nextInt(256),
                    random.nextInt(256),
                  ),
                  size: 50),
              SizedBox(width: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      group['group_name'],
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
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