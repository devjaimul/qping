import 'dart:async';

import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/app_constant.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class SocketServices {

  static var token = '';

  factory SocketServices() {

    return _socketApi;
  }
  static void init() async {
    token = await PrefsHelper.getString(AppConstants.bearerToken);
    print("Initializing socket with token: $token");

    // Validate token
    if (token.isEmpty || token == null) {
      print("Error: Token is missing or invalid.");
      return;
    }

    // Disconnect existing socket if connected
    if (socket.connected) {
      socket.disconnect();
    }

    // Reinitialize socket
    socket = IO.io(
      '${ApiConstants.imageBaseUrl}?token=$token',
      IO.OptionBuilder().setTransports(['websocket']).enableReconnection().build(),
    );

    // Setup event listeners
    socket.onConnect((_) {
      print('Socket connected successfully');
    });

    socket.onConnectError((err) {
      print('Socket connection error: $err');
    });

    socket.onError((err) {
      print('Socket error: $err');
    });

    socket.onDisconnect((reason) {
      print('Socket disconnected. Reason: $reason');
    });


    socket.connect(); // Connect to the server
  }



  SocketServices._internal();
  static final SocketServices _socketApi = SocketServices._internal();
  static IO.Socket socket = IO.io('${ApiConstants.imageBaseUrl}?token=$token',
      IO.OptionBuilder().setTransports(['websocket']).build());

  // Fetch the token asynchronously





  static Future<dynamic> emitWithAck(String event, dynamic body) async {
    Completer<dynamic> completer = Completer<dynamic>();
    socket.emitWithAck(event, body, ack: (data) {
      if (data != null) {
        completer.complete(data);
      } else {
        completer.complete(1);
      }
    });
    return completer.future;
  }


  static emit(String event, dynamic body) {
    if (socket.connected) {
      socket.emit(event, body);
      print('Emit $event with body: $body');
    } else {
      print('Socket not connected. Cannot emit event $event.');
      socket.connect(); // Attempt reconnection
    }
  }



}