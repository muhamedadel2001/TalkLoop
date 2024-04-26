import 'package:chatapp/features/home/data/chat_user_model.dart';
import 'package:chatapp/features/profile/presentation/widgets/profile_body_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/core/utilits/screens.dart' as screens;

import '../../../core/utilits/colors.dart';
import '../../auth/manager/auth_cubit.dart';
import '../../home/manager/home_cubit.dart';

class MainProfileScreen extends StatelessWidget {
  final ChatUserModel chatUserModel;

  const MainProfileScreen({
    super.key,
    required this.chatUserModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.withOpacity(0.5),
          onPressed: () async{
             await HomeCubit.get(context).updateLastSeen(false);
            AuthCubit.get(context).signOut();
            Navigator.pushNamedAndRemoveUntil(
                context, screens.logScreen, (route) => false);
          },
          child: const Icon(
            Icons.logout_outlined,
            color: Colors.white,
          ),
        ),
        extendBody: true,
        backgroundColor: mainColor.withOpacity(0.5),
        appBar: AppBar(
          backgroundColor: mainColor.withOpacity(0.5),
          centerTitle: true,
          title: const Text('Profile'),
        ),
        body: ProfileBodyScreen(chatUserModel: chatUserModel),
      ),
    );
  }
}
