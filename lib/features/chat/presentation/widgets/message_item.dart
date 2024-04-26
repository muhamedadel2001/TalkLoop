import 'package:chatapp/core/utilits/helper_functions.dart';
import 'package:chatapp/features/chat/data/message_model.dart';
import 'package:chatapp/features/chat/presentation/widgets/blue_messages.dart';
import 'package:chatapp/features/chat/presentation/widgets/green_messages.dart';
import 'package:chatapp/features/home/manager/home_cubit.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  final MessagesModel model;
  const MessageItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return HomeCubit.firebaseAuth.currentUser!.uid == model.fromId
        ? InkWell(
            onTap: () {
            HelperFunctions.showBottomSheetForGreenMessage(context, model);
            },
            child: GreenMessages(
              model: model,
            ),
          )
        : model.type==Type.image?InkWell(onTap: (){
      HelperFunctions.showBottomSheetForBlueMessage(context, model);
    },child: BlueMessages(model: model,),):BlueMessages(
            model: model,
          );
  }
}
