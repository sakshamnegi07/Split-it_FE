import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_fe/services/api_service.dart';
import 'package:split_fe/ui/groupDetails/groupDetails.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/groups_bloc.dart';
import 'bloc/groups_event.dart';
import 'bloc/groups_state.dart';
import 'package:split_fe/ui/groupDetails/bloc/group_details_bloc.dart';
import 'package:split_fe/ui/groupDetails/bloc/group_details_event.dart';
import 'package:split_fe/widgets/groups_card.dart';

class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescriptionController =
      TextEditingController();

  int? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    context.read<GroupBloc>().add(FetchGroups());
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getInt('userId');
    });
  }

  void _createGroup() {
    context.read<GroupBloc>().add(CreateGroup(
          groupName: _groupNameController.text,
          groupDescription: _groupDescriptionController.text,
        ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0, top: 3.0),
                child: Image.asset('assets/images/logo.png',
                    width: 30, height: 30),
              ),
              const Text('Groups',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add_circle_outline_outlined,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                      backgroundColor: Colors.grey[900],
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 10),
                            SizedBox(
                                height: 50,
                                width: 280,
                                child: TextFormField(
                                  controller: _groupNameController,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                  decoration: const InputDecoration(
                                    hintText: "Enter group name",
                                  ),
                                )),
                            SizedBox(
                                height: 50,
                                width: 280,
                                child: TextFormField(
                                  controller: _groupDescriptionController,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                  decoration: const InputDecoration(
                                    hintText:
                                        "Enter group description (optional)",
                                  ),
                                )),
                            const SizedBox(height: 25),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  const SizedBox(width: 50),
                                  TextButton(
                                    onPressed: _createGroup,
                                    child: const Text('DONE',
                                        style: TextStyle(
                                            color: Colors.greenAccent)),
                                  ),
                                ])
                          ],
                        ),
                      ))))
        ],
      ),
      body: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          if (state is GroupLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GroupError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is GroupsLoaded) {
            if (state.groups.isEmpty) {
              return Center(child: Text('No groups found'));
            }
            return Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ListView.builder(
                itemCount: state.groups.length,
                itemBuilder: (context, index) {
                  final group = state.groups[index];
                  bool isAdmin = currentUserId == group['created_by'];
                  return GroupCard(group: group, isAdmin: isAdmin);
                },
              ),
            );
          }
          return Center(child: Text('No groups found'));
        },
      ),
    );
  }
}

// class GroupCard extends StatelessWidget {
//   final random = Random();
//   final dynamic group;
//   final bool isAdmin;
//
//   GroupCard({required this.group, required this.isAdmin});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => BlocProvider(
//               create: (context) => GroupDetailsBloc()..add(FetchGroupDetails(groupId: group['group_id'])),
//                 child: GroupDetailsScreen(
//                     groupName: group['group_name'],
//                     groupDescription: group['group_description'],
//                     groupId: group['group_id'],
//                     isAdmin: isAdmin)),
//               ),
//                 // builder: (context) => GroupDetailsScreen(
//                 //     groupName: group['group_name'],
//                 //     groupDescription: group['group_description'],
//                 //     groupId: group['group_id'],
//                 //     isAdmin: isAdmin)),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Row(
//             children: [
//               Icon(Icons.group,
//                   color: Color.fromARGB(
//                     255,
//                     random.nextInt(256),
//                     random.nextInt(256),
//                     random.nextInt(256),
//                   ),
//                   size: 50),
//               SizedBox(width: 20),
//               Expanded(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       group['group_name'],
//                       style:
//                       TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     Icon(
//                       Icons.arrow_forward_ios,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//       color: Colors.grey[800],
//       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//     );
//   }
// }
