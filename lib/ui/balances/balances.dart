import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_fe/services/api_service.dart';
import 'package:split_fe/utils/random_icon_generator.dart';
import 'package:split_fe/dialogs/settleUpDialog.dart';
import 'package:split_fe/dialogs/remindDialog.dart';
import 'bloc/balances_bloc.dart';
import 'bloc/balances_event.dart';
import 'bloc/balances_state.dart';
import 'package:split_fe/widgets/balances_card.dart';

class BalancesScreen extends StatefulWidget {
  @override
  _BalancesScreenState createState() => _BalancesScreenState();
}

class _BalancesScreenState extends State<BalancesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BalancesBloc>().add(FetchBalances());
  }

  void _refreshData() {
    context.read<BalancesBloc>().add(RefreshBalances());
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
                const Text('Settle Up!',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
        ),
        body: BlocBuilder<BalancesBloc, BalancesState>(
          builder: (context, state) {
            if (state is BalancesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BalancesError) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is BalancesLoaded) {
              final userData = state.balances;
              final String username = userData['username'];
              final double totalAmount = userData['total_amount'].toDouble();
              final List<dynamic> balances = userData['balances'];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 10.0),
                        child: Column(
                          children: [
                            Text(
                              totalAmount >= 0.0
                                  ? 'You are owed Rs. ${totalAmount} overall!'
                                  : 'You owe Rs. ${totalAmount.abs()} overall!',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: totalAmount >= 0.0
                                      ? Colors.green[400]
                                      : Colors.orange[800]),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.black26,
                    ),
                    SizedBox(height: 20),
                    Text('Settlements:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    if (balances.isEmpty)
                      Expanded(
                          child: Center(
                              child: Text("No settlements with friends yet!"))),
                    Expanded(
                      child: ListView.builder(
                        itemCount: balances.length,
                        itemBuilder: (context, index) {
                          final balance = balances[index];
                          return BalancesCard(
                              balance: balance, onDialogClose: _refreshData);
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No data available.'));
            }
          },
        ));
  }
}
