import 'dart:convert';
import '../models/user.dart';
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../utils/toast.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../ui/login/login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:io';

class FetchedUser {
  final int id;
  final String username;
  final String email;

  FetchedUser({required this.id, required this.username, required this.email});

  factory FetchedUser.fromJson(Map<String, dynamic> json) {
    return FetchedUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
}

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 5),
      sendTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );

  static void setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException err, ErrorInterceptorHandler handler) async {
          if (err.response?.statusCode == 401 &&
              err.requestOptions.path != '$apiUrl/login') {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.clear();
            ToastService.showToast("User unauthorised. Please login again!");
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
            );
            return handler.reject(err);
          }
          return handler.next(err);
        },
      ),
    );
  }

  static Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    try {
      final response = await dio.post(
        '$apiUrl/login',
        data: jsonEncode(<String, String>{
          "email": email,
          "password": password,
        }),
      );
      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  static Future<Map<String, dynamic>> register(User user) async {
    try {
      final response = await dio.post(
        '$apiUrl/register',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: jsonEncode(user.toJson()),
      );
      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  static Future<Map<String, dynamic>> createGroup(
      {required String groupName, required String groupDesc}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      String? authToken = prefs.getString('authToken');

      if (userId == null) {
        throw Exception('User not found.');
      }
      final response = await dio.post(
        '$apiUrl/groups',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken'
          },
        ),
        data: jsonEncode(<String, dynamic>{
          "group_name": groupName,
          "group_description": groupDesc,
          "created_by": userId
        }),
      );
      return response.data;
    } on DioError catch (e) {
      return {"error": e};
    }
  }

  static Future<List<dynamic>> getGroupsByUserId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      String? authToken = prefs.getString('authToken');

      if (userId == null) {
        throw Exception('User not found.');
      }

      final response = await dio.get(
        '$apiUrl/groups/$userId',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken'
          },
        ),
      );
      return response.data;
    } catch (e) {
      ToastService.showToast("Error in fetching groups");
      return [];
    }
  }

  static Future<Map<String, dynamic>> getUserByEmail(
      {required String email}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      final response = await dio.get(
        '$apiUrl/get-user/?email=$email',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken'
          },
        ),
      );
      return response.data;
    } on DioError catch (e) {
      return {"Error": "No data found"};
    }
  }

  static Future<Map<String, dynamic>> addUserToGroup(
      {required int userId, required int groupId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      final response = await dio.post('$apiUrl/groups/members/$groupId',
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $authToken'
            },
          ),
          data: {'user_id': userId});
      return response.data;
    } on DioError catch (e) {
      return e.response?.data;
    }
  }

  static Future<Map<String, dynamic>> removeMemberFromGroup(
      {required int groupId, required int userId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      final response =
          await dio.delete('$apiUrl/groups/members/$groupId/delete/$userId',
              options: Options(
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer $authToken'
                },
              ));
      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  static Future<List<dynamic>> getGroupMembers({required int groupId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      final response = await dio.get(
        '$apiUrl/groups/members/$groupId',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken'
          },
        ),
      );
      return response.data;
    } catch (e) {
      ToastService.showToast("Error in fetching members!");
      return [];
    }
  }

  static Future<List<dynamic>> getGroupExpenses({required int groupId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      final response = await dio.get(
        '$apiUrl/expenses/$groupId',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken'
          },
        ),
      );
      return response.data;
    } on DioError catch (e) {
      ToastService.showToast("Error in fetching expenses!");
      return [];
    }
  }

  static Future<Map<String, dynamic>> addExpenseToGroup(
      {required int groupId,
      required String description,
      required double amount,
      required int paidBy}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');
      int? userId = prefs.getInt('userId');

      final response = await dio.post('$apiUrl/expenses/add-expense',
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $authToken'
            },
          ),
          data: {
            "paid_by": paidBy,
            "amount": amount,
            "group_id": groupId,
            "description": description
          });
      return response.data;
    } on DioException catch (e) {
      return {"error": "Expense couldn't be added"};
    }
  }

  static Future<double> getOverallGroupBalance({required int groupId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      final response =
          await dio.get('$apiUrl/expenses/overall-expense/${groupId}',
              options: Options(
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer $authToken'
                },
              ));
      return response.data['total_balance'].toDouble();
    } on DioError catch (e) {
      ToastService.showToast("Failed to get overall balance!");
      return 0.0;
    }
  }

  static Future<Map<String, dynamic>> getUserDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      final response = await dio.get('$apiUrl/user/details',
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $authToken'
            },
          ));
      return response.data;
    } on DioException catch (e) {
      ToastService.showToast("Failed to fetch user details!");
      return {};
    }
  }

  static Future<Map<String, dynamic>> getUserBalances() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      final response = await dio.get('$apiUrl/balances/',
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $authToken'
            },
          ));
      return response.data;
    } on DioException catch (e) {
      ToastService.showToast("Failed to fetch settlements!");
      return e.response?.data;
    }
  }

  static Future<Map<String, dynamic>> settleBalance(
      {required int receiverId, required double amount}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      final response = await dio.post('$apiUrl/settle',
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $authToken'
            },
          ),
          data: {
            "borrower": receiverId,
            "amount": amount,
          });
      return response.data;
    } on DioException catch (e) {
      return {"Error": "Error while settling balance!"};
    }
  }

  static Future<List<dynamic>> getPaymentHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      final response = await dio.get('$apiUrl/payments',
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $authToken'
            },
          ));
      return response.data;
    } on DioError catch (e) {
      ToastService.showToast("Failed to fetch payments!");
      return [];
    }
  }

  static Future<Map<String, dynamic>> sendPaymentReminderEmail(
      {required int borrowerId, required double amount}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      final response = await dio.post('$apiUrl/remind-user',
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $authToken'
            },
          ),
          data: {"borrower": borrowerId, "amount": amount});
      return response.data;
    } on DioError catch (e) {
      ToastService.showToast("Failed to fetch settlements!");
      return {};
    }
  }

  static Future<void> downloadFile(
      {required String url, required String fileName}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }
      String finalUrl = '$apiUrl' + '/download/payments/' + url;
      final taskId = await FlutterDownloader.enqueue(
        url: finalUrl,
        headers: {
          'Authorization': 'Bearer $authToken',
          // 'Content-Type': "text/csv",
        },
        savedDir: downloadsDirectory.path,
        fileName: 'Payments.csv',
        showNotification: true,
        openFileFromNotification: true,
      );
      await _waitForDownloadCompletion(taskId!);
      await FlutterDownloader.open(taskId: taskId!);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Can not download file.");
    }
  }

  static Future<void> _waitForDownloadCompletion(String taskId) async {
    bool isComplete = false;
    while (!isComplete) {
      await Future.delayed(Duration(milliseconds: 500));
      final tasks = await FlutterDownloader.loadTasks();
      final task = tasks?.firstWhere((task) => task.taskId == taskId);
      if (task?.status == DownloadTaskStatus.complete) {
        isComplete = true;
      }
    }
  }

  static Future<bool> isTokenValid(String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');
      await Future.delayed(Duration(seconds: 1));
      final response = await dio.get(
        '$apiUrl/validate-user',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken'
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
