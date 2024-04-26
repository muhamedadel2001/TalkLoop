import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/core/utilits/helper_functions.dart';
import 'package:chatapp/core/widgets/call_invitation.dart';
import 'package:chatapp/features/chat/manager/chat_cubit.dart';
import 'package:chatapp/features/home/data/chat_user_model.dart';
import 'package:chatapp/features/home/manager/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatapp/core/utilits/screens.dart' as screens;
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ChatAppBarSection extends StatefulWidget {
  final ChatUserModel model;
  const ChatAppBarSection({super.key, required this.model});
  @override
  State<ChatAppBarSection> createState() => _ChatAppBarSectionState();
}

class _ChatAppBarSectionState extends State<ChatAppBarSection> {
  @override
  void initState() {
    HomeCubit.get(context).getSelfUser(widget.model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, screens.viewProfileScreen,
                arguments: widget.model);
          },
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.sp),
                  child: CachedNetworkImage(
                    width: 44.w,
                    height: 44.h,
                    fit: BoxFit.fill,
                    imageUrl: widget.model.image,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(Icons.person)),
                  ),
                ),
              ),
              SizedBox(
                width: 8.sp,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        widget.model.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    HomeCubit.get(context).models2.isNotEmpty
                        ? Flexible(
                            child: Text(
                              HomeCubit.get(context).models2[0].isOnline
                                  ? 'Online'
                                  : HelperFunctions.getLastActiveTime(
                                      context: context,
                                      lastActive: HomeCubit.get(context)
                                          .models2[0]
                                          .lastActive),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CallInvitationPage(
                                config: ZegoUIKitPrebuiltCallConfig
                                    .oneOnOneVoiceCall(),
                                id: widget.model.id,
                                name: widget.model.name,
                                callId: ChatCubit.get(context)
                                    .getConversationId(widget.model.id))));
                  },
                  child: Icon(
                    Icons.call,
                    color: Colors.white,
                    size: 25.sp,
                  )),
              SizedBox(
                width: 25.w,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CallInvitationPage(
                                config: ZegoUIKitPrebuiltCallConfig
                                    .oneOnOneVideoCall(),
                                id: widget.model.id,
                                name: widget.model.name,
                                callId: ChatCubit.get(context)
                                    .getConversationId(widget.model.id))));
                  },
                  child: Icon(
                    Icons.video_call,
                    color: Colors.white,
                    size: 25.sp,
                  )),
              SizedBox(
                width: 20.w,
              )
            ],
          ),
        );
      },
    );
  }
}
