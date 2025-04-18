import "../db/UserDatabaseHelper.dart";
import "package:app_02/userMS/model/User.dart";
import "package:app_02/userMS/view/UserListItem.dart";
import "package:app_02/userMS/view/AddUserScreen.dart";
import "package:app_02/userMS/view/EditUserScreen.dart";
import "package:flutter/material.dart";

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  Future<void> _refreshUsers() async {
    setState(() {
      _usersFuture = UserDatabaseHelper.instance.getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách người dùng'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshUsers,
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Không có người dùng nào'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return UserListItem(
                  user: user,
                  onDelete: () async {
                    await UserDatabaseHelper.instance.deleteUser(user.id!);
                    _refreshUsers();
                  },
                  onEdit: () async {
                    //Phần cập nhật
                    // Navigate to edit screen
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditUserScreen(user: user),
                      ),
                    );
                    if (updated == true) {
                      _refreshUsers();
                    }
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          //Phần thêm mới
          final created = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUserScreen(),
            ),
          );
          if (created == true) {
            _refreshUsers();
          }
        },
      ),
    );
  }
}
