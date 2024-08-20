import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_fe/ui/groups/groups.dart';
import 'package:split_fe/ui/home/home.dart';
import 'package:split_fe/ui/profile/profilePage.dart';
import 'package:split_fe/ui/balances/balances.dart';
import 'package:split_fe/ui/history/history.dart';
import 'bloc/landing_page_bloc.dart';
import 'bloc/landing_page_event.dart';
import 'bloc/landing_page_state.dart';
import 'package:split_fe/ui/balances/bloc/balances_bloc.dart';
import 'package:split_fe/ui/balances/bloc/balances_event.dart';
import 'package:split_fe/ui/history/bloc/history_bloc.dart';
import 'package:split_fe/ui/profile/bloc/profile_bloc.dart';
import 'package:split_fe/ui/groups/bloc/groups_bloc.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int selectedPage = 0;

  final List<Widget> _pageOptions = [
    BlocProvider(
      create: (context) => GroupBloc(),
      child: GroupScreen(),
    ),
    BlocProvider(
      create: (context) => BalancesBloc()..add(FetchBalances()),
      child: BalancesScreen(),
    ),
    BlocProvider(
      create: (context) => HistoryBloc(),
      child: HistoryScreen(),
    ),
    BlocProvider(
      create: (context) => ProfileBloc(),
      child: ProfileScreen(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LandingBloc(),
      child: Scaffold(
        body: BlocBuilder<LandingBloc, LandingState>(
          builder: (context, state) {
            if (state is PageLoaded) {
              return _pageOptions[state.pageIndex];
            }
            return _pageOptions[selectedPage];
          },
        ),
        bottomNavigationBar: BlocBuilder<LandingBloc, LandingState>(
          builder: (context, state) {
            int currentIndex = selectedPage;
            if (state is PageLoaded) {
              currentIndex = state.pageIndex;
            }

            return Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white, width: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.group, size: 30),
                    label: 'Groups',
                    backgroundColor: Colors.black87,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person, size: 30),
                    label: 'Balances',
                    backgroundColor: Colors.black87,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.file_open, size: 30),
                    label: 'Activity',
                    backgroundColor: Colors.black87,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle, size: 30),
                    label: 'Profile',
                    backgroundColor: Colors.black87,
                  ),
                ],
                showUnselectedLabels: true,
                selectedItemColor: Colors.cyan,
                unselectedItemColor: Colors.white,
                currentIndex: currentIndex,
                backgroundColor: Colors.black87,
                onTap: (index) {
                  setState(() {
                    selectedPage = index;
                  });
                  context.read<LandingBloc>().add(PageSelected(index));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}