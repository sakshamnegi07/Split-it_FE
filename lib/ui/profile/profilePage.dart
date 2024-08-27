import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_fe/utils/toast.dart';
import 'package:split_fe/services/api_service.dart';
import 'dart:math';
import 'package:split_fe/dialogs/logoutDialog.dart';
import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchUserDetails());
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
                const Text('Account',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Card
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ProfileError) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else if (state is ProfileLoaded) {
                    final user = state.userDetails;
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user['username']}' ?? '',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Text(
                              '${user['email']}' ?? '',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      color: Colors.grey[700],
                    );
                  }
                  return Center(child: Text('No data found'));
                },
              ),
              // Logout Card
              Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red, size: 40),
                  title: Text('Logout',
                      style: TextStyle(
                          color: Colors.red[500],
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => LogoutDialog()),
                ),
                color: Colors.grey[700],
              ),
            ],
          ),
        ));
  }
}
