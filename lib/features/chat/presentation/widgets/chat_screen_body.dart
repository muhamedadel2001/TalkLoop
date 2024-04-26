import 'dart:io';

import 'package:chatapp/features/chat/manager/chat_cubit.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_input_field_section.dart';
import 'package:chatapp/features/chat/presentation/widgets/message_item.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utilits/colors.dart';
import '../../../home/data/chat_user_model.dart';

class ChatScreenBody extends StatefulWidget {
  final ChatUserModel model;

  const ChatScreenBody({super.key, required this.model});

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  late ChatCubit cubit;

  @override
  void initState() {
    cubit = ChatCubit.get(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return Column(
          children: [
            cubit.messages.isNotEmpty
                ? Expanded(child: BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      if (state is GetMessagesLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is GetMessagesSuccess ||
                          state is GetLastMessage ||
                          state is ChatEmojiChange ||
                          state is StartRecorded ||
                          state is UploadedRecorded ||
                          state is Uploaded ||
                          state is DeleteMessageSuccess ||
                          state is UpdateMessageSuccess) {
                        return ListView.separated(
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageItem(model: cubit.messages[index]);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 5.h,
                            );
                          },
                          itemCount: cubit.messages.length,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ))
                : Expanded(
                    child: Center(
                      child: Text(
                        'Say Hi! 👋',
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    ),
                  ),
            if (state is StopRecorded)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.grey,
                  ),
                ),
              ),
            if (cubit.isUpload)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.grey,
                  ),
                ),
              ),
            ChatInputFieldSection(model: widget.model),
            cubit.chatImoji == true
                ? SizedBox(
                    height: 250.h,
                    child: EmojiPicker(
                      textEditingController: cubit.textEditingController,
                      config: Config(
                        bgColor: mainColor.withOpacity(0.5),
                        columns: 7,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        );
      },
    );
  }
}
