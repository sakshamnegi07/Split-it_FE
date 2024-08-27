import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_fe/utils/toast.dart';
import 'package:split_fe/services/api_service.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/history_bloc.dart';
import 'bloc/history_event.dart';
import 'bloc/history_state.dart';
import 'package:split_fe/widgets/payments_card.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    context.read<HistoryBloc>().add(FetchHistory());
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getInt('userId');
    });
  }

  void downloadYourActivity() async {
    try {
      await ApiService.downloadFile(url: 'csv', fileName: "Payments.csv");
      ToastService.showToast("Download completed!");
    } catch (e) {
      print(e);
      ToastService.showToast("Error");
    }
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
              const Text('Activity',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_download,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () => downloadYourActivity(),
          )
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is HistoryError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is HistoryLoaded) {
            if (state.payments.isEmpty) {
              return Center(child: Text('No payments found!'));
            }
            return Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ListView.builder(
                itemCount: state.payments.length,
                itemBuilder: (context, index) {
                  return PaymentsCard(
                    paymentData: state.payments[index],
                    currentUserId: currentUserId,
                  );
                },
              ),
            );
          }
          return Center(child: Text('No payments found!'));
        },
      ),
    );
  }
}
