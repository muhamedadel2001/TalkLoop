import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/core/utilits/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../home/data/chat_user_model.dart';

class ImageProfileSection extends StatefulWidget {
  final ChatUserModel chatUserModel;
  const ImageProfileSection({super.key, required this.chatUserModel});

  @override
  State<ImageProfileSection> createState() => _ImageProfileSectionState();
}

class _ImageProfileSectionState extends State<ImageProfileSection> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        HelperFunctions.imagePicked == ''
            ? ClipRRect(
                borderRadius: BorderRadius.circular(90.sp),
                child: CachedNetworkImage(
                  width: 180.w,
                  height: 180.h,
                  fit: BoxFit.fill,
                  imageUrl: widget.chatUserModel.image,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          color: Colors.grey, value: downloadProgress.progress),
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(Icons.person)),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(90.sp),
                child: Image.file(
                  File(HelperFunctions.imagePicked),
                  width: 180.w,
                  height: 180.h,
                  fit: BoxFit.fill,
                ),
              ),
        MaterialButton(
          shape: const CircleBorder(),
          color: Colors.grey.shade700,
          onPressed: () async {
            await HelperFunctions.showBottomSheet(context);
            setState(() {});
          },
          child: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
