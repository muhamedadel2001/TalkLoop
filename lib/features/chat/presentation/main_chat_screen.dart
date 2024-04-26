import 'package:chatapp/features/chat/manager/chat_cubit.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_app_bar_section.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_screen_body.dart';
import 'package:chatapp/features/home/data/chat_user_model.dart';
import 'package:flutter/material.dart';

import '../../../core/utilits/colors.dart';

class MainChatScreen extends StatefulWidget {
  final ChatUserModel model;

  const MainChatScreen({super.key, required this.model});

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  @override
  void initState() {
    ChatCubit.get(context).getAllMessage(widget.model);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if (ChatCubit
              .get(context)
              .chatImoji) {
            ChatCubit.get(context).checkEmoji();
            return Future.value(false);
          }
          else {
            return Future.value(true);
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: mainColor.withOpacity(0.5),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: mainColor.withOpacity(0.5),
              automaticallyImplyLeading: false,
              flexibleSpace: ChatAppBarSection(model: widget.model),
            ),
            body: ChatScreenBody(model: widget.model),
          ),
        ),
      ),
    );
  }
}
