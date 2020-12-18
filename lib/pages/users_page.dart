import 'package:chat_flutter/models/user.dart';
import 'package:chat_flutter/pages/pages.dart';
import 'package:chat_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {
  static final String route = 'UsersPage';

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final friends = [
    User(uid: '1', name: 'Lucas', email: 'marionis@gmail.com', online: false),
    User(uid: '2', name: 'Mendez', email: 'mendez@gmail.com', online: true),
    User(uid: '3', name: 'Samuel', email: 'samuel@gmail.com', online: true),
    User(
        uid: '4', name: 'Dislenia', email: 'dislenia@gmail.com', online: false),
    User(uid: '5', name: 'Daris', email: 'daris@gmail.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(user?.name ?? '', style: TextStyle(color: Colors.black54)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: true
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.offline_bolt, color: Colors.red),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: () {
            Navigator.pushReplacementNamed(context, LoginPage.route);
            AuthService.deleteToken();
          },
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        header: WaterDropHeader(),
        onRefresh: _onRefresh,
        enablePullDown: true,
        child: _buildListView(),
      ),
    );
  }

  ListView _buildListView() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _buildListTileUser(friends[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: friends.length,
    );
  }

  ListTile _buildListTileUser(User user) {
    return ListTile(
      title: Text(user.name ?? ''),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[400],
        child: Text(
          user.name.substring(0, 2),
          style: TextStyle(color: Colors.white),
        ),
      ),
      trailing: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          color: user.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
