import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/core/utilits/colors.dart';
import 'package:chatapp/core/utilits/helper_functions.dart';
import 'package:chatapp/features/chat/manager/chat_cubit.dart';
import 'package:chatapp/features/home/data/chat_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatapp/core/utilits/screens.dart' as screens;

class ListViewItem extends StatefulWidget {
  const ListViewItem({super.key, required this.model});
  final ChatUserModel model;

  @override
  State<ListViewItem> createState() => _ListViewItemState();
}

class _ListViewItemState extends State<ListViewItem> {
  @override
  void initState() {
    ChatCubit.get(context).getLastMessage(widget.model);
    super.initState();
  }

  @override
  @override
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, screens.chatScreen,
            arguments: widget.model);
      },
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp)),
              color: mainColor.withOpacity(0.5),
              elevation: 2,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(20.sp),
                  child: CachedNetworkImage(
                    width: 44.w,
                    height: 44.h,
                    fit: BoxFit.cover,
                    imageUrl: widget.model.image,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(Icons.person)),
                  ),
                ),
                title: Text(
                  widget.model.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                  ),
                ),
                subtitle: ChatCubit.get(context).dataType == ''
                    ? Text(
                        widget.model.about,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.sp,
                        ),
                      )
                    : ChatCubit.get(context).dataType == 'text'
                        ? Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            ChatCubit.get(context).lastMessage,
                            style:
                                TextStyle(color: Colors.grey, fontSize: 13.sp),
                          )
                        : ChatCubit.get(context).dataType == 'image'
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.camera_alt_sharp,
                                  color: Colors.grey,
                                  size: 20.sp,
                                ))
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.mic,
                                  color: Colors.grey,
                                  size: 20.sp,
                                )),
                trailing: ChatCubit.get(context).checkIfRead.isNotEmpty
                    ? Container(
                        width: 10.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.greenAccent.shade700),
                      )
                    : Text(
                        ChatCubit.get(context).lastSent != ''
                            ? HelperFunctions.getLastMessage(
                                context: context,
                                time: ChatCubit.get(context).lastSent)
                            : '',
                        style: TextStyle(color: Colors.white, fontSize: 15.sp),
                      ),

                /* trailing: const Text(
              '12:00 Pm',
              style: TextStyle(color: Colors.grey),
            ),*/
              ));
        },
      ),
    );
  }
}
