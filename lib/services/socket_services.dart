import 'dart:async';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/app_constant.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../helpers/prefs_helper.dart';


class SocketServices {

  static var token = '';

  factory SocketServices() {
    return _socketApi;
  }



  SocketServices._internal();

  static final SocketServices _socketApi = SocketServices._internal();
  static IO.Socket socket = IO.io(ApiConstants.imageBaseUrl,
      IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders({"authorization":'Bearer ${token}'}).build());




  static void init() async{
    token = await PrefsHelper.getString(AppConstants.bearerToken);


    print("-------------------------------------------------------------------------------------------Socket call");
    if (!socket.connected) {
      socket.onConnect((_) {
        print('========> socket connected: ${socket.connected}');
      });

      socket.onConnectError((err) {
        print('========> socket connect error: $err');
      });


      socket.onDisconnect((_) {
        print('========> socket disconnected');
      });
    } else {
      print("=======> socket already connected");
    }
  }

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
    if (body != null) {
      socket.emit(event, body);
      print('===========> Emit $event and \n $body');
    }
  }
}