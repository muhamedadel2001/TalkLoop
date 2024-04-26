import 'package:chatapp/core/utilits/api.dart';
import 'package:chatapp/features/home/data/chat_user_model.dart';
import 'package:chatapp/features/profile/presentation/widgets/image_profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'form_and_button_profile_section.dart';

class ProfileBodyScreen extends StatelessWidget {
  final ChatUserModel chatUserModel;

  const ProfileBodyScreen({
    super.key,
    required this.chatUserModel,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 35.h,
              ),
              ImageProfileSection(chatUserModel: chatUserModel),
              SizedBox(
                height: 20.h,
              ),
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                Apis.auth.currentUser!.email.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 15.h,
              ),
              FormAndButtonProfileSection(
                chatUserModel: chatUserModel,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
