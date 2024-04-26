import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallInvitationPage extends StatelessWidget {
  const CallInvitationPage({
    super.key,
    required this.callId, required this.id, required this.name, required this.config,
  });

  final String callId;
  final String id;
  final String name;
  final ZegoUIKitPrebuiltCallConfig config;


  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID: 1238198228,
        appSign:
            'bf3307336cd354b15e8e3aa74c0c3a71668ac2ec744f80496deb550b6754bf4d',
        callID: callId,
        userID: id,
        userName: name,
        config:config);
  }
}
