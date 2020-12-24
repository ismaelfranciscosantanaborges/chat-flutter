import 'package:chat_flutter/global/environment.dart';
import 'package:chat_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  void connect() async {
    String token = await AuthService.getToken();

    this._socket = IO.io(
      Environment.urlSocket,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .setExtraHeaders({'x-token': token})
          .build(),
    );

    this._socket.onConnect((payload) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((payload) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    this._socket.disconnect();
  }
}
