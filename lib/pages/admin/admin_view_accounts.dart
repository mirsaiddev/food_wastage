import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_wastage/helpers/show.dart';
import 'package:food_wastage/services/firestore_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminViewAccounts extends StatefulWidget {
  const AdminViewAccounts({Key? key}) : super(key: key);

  @override
  _AdminViewAccountsState createState() => _AdminViewAccountsState();
}

class _AdminViewAccountsState extends State<AdminViewAccounts> {
  var _items = ['User', 'Food Recipient'];
  String _value = 'User';
  List<QueryDocumentSnapshot<Object?>> _users = [];
  bool _loadingDone = false;
  Future<void> _getUsers(String type) async {
    _users = await FirestoreService().getAllUsers(type);
    _loadingDone = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUsers(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Account Type : '),
              const SizedBox(width: 14),
              DropdownButton(
                value: _value,
                items: _items.map((String items) {
                  return DropdownMenuItem(value: items, child: Text(items));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _value = newValue.toString();
                    _getUsers(newValue.toString());
                  });
                },
              ),
            ],
          ),
          _loadingDone
              ? _users.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          Map _user = _users[index].data() as Map;
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.w),
                            child: Card(
                              child: ExpansionTile(
                                title: Text(_user['username']),
                                subtitle: Text(_user['role']),
                                children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 22.h),
                                        child: Text('Email : ${_user['email']}'),
                                      )),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 22.h),
                                        child: Text('UID : ${_user['uid']}'),
                                      )),
                                  TextButton(
                                    onPressed: () {
                                      Show.dialog(
                                          context,
                                          AlertDialog(
                                            title: Text('Warning!'),
                                            content: Text('Are you sure that you want to delete this user?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Cancel')),
                                              TextButton(
                                                  onPressed: () async {
                                                    await FirestoreService().deleteUser(_user['uid']);
                                                    _users.removeWhere(
                                                        (element) => (element.data() as Map)['uid'] == (_users[index].data() as Map)['uid']);
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                    Show.snackbar(context, 'User deleted successfully');
                                                  },
                                                  child: Text('Delete')),
                                            ],
                                          ));
                                    },
                                    child: Text('Delete This User'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: Text('No Users Exists'),
                      ),
                    )
              : Expanded(child: Center(child: CircularProgressIndicator()))
        ],
      ),
    );
  }
}
