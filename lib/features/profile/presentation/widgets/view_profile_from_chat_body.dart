import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/features/home/data/chat_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ViewProfileFromChatBody extends StatelessWidget {
  final ChatUserModel chatUserModel;
  const ViewProfileFromChatBody({super.key, required this.chatUserModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 65.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 35.h,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(90.sp),
                child: CachedNetworkImage(
                  width: 180.w,
                  height: 180.h,
                  fit: BoxFit.fill,
                  imageUrl: chatUserModel.image,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          color: Colors.grey, value: downloadProgress.progress),
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(Icons.person)),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                textAlign: TextAlign.center,
                chatUserModel.email,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'About: ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp),
                  ),
                  Text(
                    chatUserModel.about,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
