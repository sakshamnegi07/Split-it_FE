import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/toast.dart';

class UserSearchDialog extends StatefulWidget {
  final int groupId;
  UserSearchDialog({required this.groupId});

  @override
  _UserSearchDialogState createState() => _UserSearchDialogState();
}

class _UserSearchDialogState extends State<UserSearchDialog> {
  final TextEditingController _searchEmailController = TextEditingController();
  Map<String, dynamic>? _searchedUser;
  bool _isLoading = false;

  void _searchUserByEmail() async {
    setState(() {
      _isLoading = true;
      _searchedUser = null;
    });
    try {
      final data = await ApiService.getUserByEmail(
          email: _searchEmailController.text.trim());
      setState(() {
        if (!data.containsKey('Error'))
          _searchedUser = data;
        else
          ToastService.showToast("No user found with that id!");
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching user data: $e');
    }
  }

  void _addUserToGroup() async {
    try {
      final data = await ApiService.addUserToGroup(
          userId: _searchedUser!['id'], groupId: widget.groupId);
      setState(() {
        if (!data.containsKey('Error')) {
          Navigator.pop(context, "Member added!");
          ToastService.showToast('Member successfully added!');
        } else
          ToastService.showToast(data['Error']);
        _isLoading = false;
      });
    } catch (e) {
      ToastService.showToast("Error!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                controller: _searchEmailController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Search users by email-id",
                  hintStyle: TextStyle(color: Colors.white70),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search_outlined),
                    color: Colors.white70,
                    onPressed: () => _searchUserByEmail(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            _isLoading
                ? CircularProgressIndicator()
                : _searchedUser != null
                    ? Card(
                        color: Colors.grey[800],
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${_searchedUser!['username']}',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(
                                height: 25,
                                width: 80,
                                child: ElevatedButton(
                                  onPressed: _addUserToGroup,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[600],
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('Add'),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
