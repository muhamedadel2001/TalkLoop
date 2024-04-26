import 'dart:io';

import 'package:chatapp/core/utilits/colors.dart';
import 'package:chatapp/features/chat/manager/chat_cubit.dart';
import 'package:chatapp/features/home/data/chat_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatapp/features/chat/data/message_model.dart';
import 'package:image_picker/image_picker.dart';

class ChatInputFieldSection extends StatelessWidget {
  final ChatUserModel model;
  const ChatInputFieldSection({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.sp)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        ChatCubit.get(context).checkEmoji();
                      },
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: mainColor,
                      )),
                  Expanded(
                      child: TextField(
                    onTap: () {
                      if (ChatCubit.get(context).chatImoji) {
                        ChatCubit.get(context).checkEmoji();
                      }
                    },
                    controller: ChatCubit.get(context).textEditingController,
                    keyboardType: TextInputType.multiline,scrollPadding: EdgeInsets.symmetric(vertical: 10.h),
                    maxLines: null,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () async {
                        if (!ChatCubit.get(context).isRecord) {
                          ChatCubit.get(context).startRecord();
                        } else {
                          await ChatCubit.get(context).stopRecord();
                          await ChatCubit.get(context).upload(model);
                        }
                      },
                      icon: ChatCubit.get(context).isRecord
                          ? const Icon(Icons.stop, color: mainColor)
                          : const Icon(Icons.mic, color: mainColor)),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final List<XFile> images =
                            await picker.pickMultiImage();
                        if (images.isNotEmpty) {
                          for (var i in images) {
                            ChatCubit.get(context).checkUploading(true);
                            await ChatCubit.get(context)
                                .sentChatImage(model, File(i.path));
                            ChatCubit.get(context).checkUploading(false);
                          }
                        }
                      },
                      icon: const Icon(Icons.image, color: mainColor)),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          ChatCubit.get(context).checkUploading(true);
                          await ChatCubit.get(context)
                              .sentChatImage(model, File(image.path));
                          ChatCubit.get(context).checkUploading(false);
                        }
                      },
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: mainColor)),
                ],
              ),
            ),
          ),
          MaterialButton(
            minWidth: 0,
            shape: const CircleBorder(),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 15.h),
            color: Colors.green,
            onPressed: () {
              if (ChatCubit.get(context)
                  .textEditingController
                  .text
                  .isNotEmpty) {
                if (ChatCubit.get(context).messages.isNotEmpty) {

                  ChatCubit.get(context).sendMessage(
                      model,
                      ChatCubit.get(context).textEditingController.text,
                      Type.text);
                  ChatCubit.get(context).textEditingController.text = '';
                } else {
                  ChatCubit.get(context).sendFirstMessage(
                      model,
                      ChatCubit.get(context).textEditingController.text,
                      Type.text,
                      context);
                  ChatCubit.get(context).textEditingController.text = '';
                }
              }
            },
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
