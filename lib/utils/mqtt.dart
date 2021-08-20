import 'dart:math';

import 'package:behtarino_chat/screens/chat/chat_md.dart';
import 'package:behtarino_chat/screens/chat/chat_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';

class MQTT {
  final BuildContext context;
  late MqttServerClient client;


  MQTT(this.context);

  Future<MqttServerClient> connect(String topic) async {
    client = MqttServerClient.withPort('185.86.181.206', 'happy_chat', 31789);
    client.logging(on: false);
    client.keepAlivePeriod = 36000;
    client.onConnected = () => onConnected(topic);
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;

    final connMessage = MqttConnectMessage()
        .authenticateAs('challenge', '8dAtPHvjPNC4erjFRfy')
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }
    return client;
  }

  void onConnected(String topic)  {
    print('Connected');
    client.subscribe(topic, MqttQos.atLeastOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      // ignore: avoid_as
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      // final MqttPublishMessage recMess = c![0].payload;
      final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final chatVM = context.read<ChatViewModel>();
      var sendMsg = Message(id:Random().nextInt(999999),message: pt, fromMe: true);
      chatVM.setChatMessages([...chatVM.chatMessages,sendMsg]);
      chatVM.addToHive(sendMsg);
      var receiveMsg = Message(id:Random().nextInt(99999999),message: pt, fromMe: false);
      chatVM.setChatMessages([...chatVM.chatMessages,receiveMsg]);
      chatVM.addToHive(receiveMsg);
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    });
  }

  void onDisconnected() {
    print('Disconnected');
  }

  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

  void onUnsubscribed(String? topic) {
    print('Unsubscribed topic: $topic');
  }

  void pong() {
    print('Ping response client callback invoked');
  }

  void publish(
      {required String message, required MqttServerClient client,required  String topic, required String box}) async {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);



  }
}