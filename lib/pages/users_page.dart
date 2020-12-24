import 'package:chat_flutter/models/user.dart';
import 'package:chat_flutter/pages/pages.dart';
import 'package:chat_flutter/services/auth_service.dart';
import 'package:chat_flutter/services/chat_service.dart';
import 'package:chat_flutter/services/socket_service.dart';
import 'package:chat_flutter/services/users_service.dart';
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

  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).user;
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(user?.name ?? '', style: TextStyle(color: Colors.black54)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.offline_bolt, color: Colors.red),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: () {
            socketService.disconnect();
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
      itemBuilder: (_, i) => _buildListTileUser(users[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: users.length,
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
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onTap: () {
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.userfrom = user;
          debugPrint(user.name);
          debugPrint(user.email);

          Navigator.pushNamed(context, ChatPage.route);
        });
  }

  void _onRefresh() async {
    final usersService = UsersServices();
    this.users = await usersService.getUsers();

    setState(() {});

    _refreshController.refreshCompleted();
  }
}
