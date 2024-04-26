import 'package:chatapp/core/utilits/helper_functions.dart';
import 'package:chatapp/features/home/data/chat_user_model.dart';
import 'package:chatapp/features/profile/presentation/widgets/view_profile_from_chat_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utilits/colors.dart';

class ViewProfileFromChat extends StatelessWidget {
  final ChatUserModel chatUserModel;
  const ViewProfileFromChat({super.key, required this.chatUserModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Joined: ',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp),
          ),
          Text(
            HelperFunctions.getLastMessage(
                context: context, time: chatUserModel.createdAt),
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          )
        ],
      ),
      extendBody: true,
      backgroundColor: mainColor.withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: mainColor.withOpacity(0.5),
        centerTitle: true,
        title: Text(chatUserModel.name),
      ),
      body: ViewProfileFromChatBody(chatUserModel: chatUserModel),
    );
  }
}
