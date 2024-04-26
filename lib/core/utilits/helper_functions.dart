import 'dart:io';

import 'package:chatapp/core/utilits/dialogs.dart';
import 'package:chatapp/features/chat/data/message_model.dart';
import 'package:chatapp/features/chat/manager/chat_cubit.dart';
import 'package:chatapp/features/chat/presentation/widgets/option_item.dart';
import 'package:chatapp/features/home/manager/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class HelperFunctions {
  static String imagePicked = '';
  static Future<void> showBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp),
                topRight: Radius.circular(20.sp))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
            children: [
              Text(
                textAlign: TextAlign.center,
                'Pick Profile Picture',
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: Size(90.w, 110.h),
                        shape: const CircleBorder(),
                      ),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          imagePicked = image.path;
                          HomeCubit.get(context)
                              .updateProfilePicture(File(imagePicked));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/images/add_image.png')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: Size(90.w, 110.h),
                        shape: const CircleBorder(),
                      ),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          imagePicked = image.path;
                          HomeCubit.get(context)
                              .updateProfilePicture(File(imagePicked));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/images/camera.png')),
                ],
              )
            ],
          );
        });
  }

  static String getFormatTime(
      {required BuildContext context, required String time}) {
    var data = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(data).format(context);
  }

  static String getLastMessage(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return '${sent.day}${getMonth(sent)}';
  }

  static String getMonth(DateTime time) {
    switch (time.month) {
      case 1:
        return ' Jan';
      case 2:
        return ' Feb';
      case 3:
        return ' Mar';
      case 4:
        return ' Apr';
      case 5:
        return ' May';
      case 6:
        return ' Jun';
      case 7:
        return ' Jul';
      case 8:
        return ' Aug';
      case 9:
        return ' Sep';
      case 10:
        return ' Oct';
      case 11:
        return ' Nov';
      case 12:
        return ' Dec';
    }
    return 'NA';
  }

  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    if (i == -1) return 'Last seen not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == time.year) {
      return 'Last seen today at $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    String month = getMonth(time);

    return 'Last seen on ${time.day} $month on $formattedTime';
  }

  static String getMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }
    return now.year == sent.year
        ? "$formattedTime - ${sent.day} ${getMonth(sent)} "
        : "$formattedTime - ${sent.day} ${getMonth(sent)}${sent.year} }";
  }

  static Future<void> showBottomSheetForBlueMessage(
      BuildContext context, MessagesModel messagesModel) async {
    await showModalBottomSheet(
      
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp),
                topRight: Radius.circular(20.sp))),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin:
                    EdgeInsets.symmetric(horizontal: 130.sp, vertical: 20.h),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),
              OptionItem(
                  onTap: () async {
                    await GallerySaver.saveImage(messagesModel.msg,
                            albumName: 'Chats')
                        .then((value) {
                      Navigator.pop(context);
                      if (value != null && value) {
                        Dialogs.showSnackBar(
                            context, 'Image Successfully Saved!');
                      }
                    });
                  },
                  name: 'Save Image',
                  icon: const Icon(
                    Icons.upload,
                    color: Colors.black,
                  ))
            ],
          );
        });
  }

  static Future<void> showBottomSheetForGreenMessage(
      BuildContext context, MessagesModel messagesModel) async {
    await showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp),
                topRight: Radius.circular(20.sp))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin:
                    EdgeInsets.symmetric(horizontal: 130.sp, vertical: 20.h),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),
              messagesModel.type == Type.text
                  ? OptionItem(
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: messagesModel.msg))
                            .then((value) {
                          Navigator.pop(context);
                          Dialogs.showSnackBar(context, 'Text Copied!');
                        });
                      },
                      name: 'Copy Text',
                      icon: const Icon(
                        Icons.copy_all_rounded,
                        color: Colors.black,
                      ))
                  : messagesModel.type == Type.image
                      ? OptionItem(
                          onTap: () async {
                            await GallerySaver.saveImage(messagesModel.msg,
                                    albumName: 'Chats')
                                .then((value) {
                              Navigator.pop(context);
                              if (value != null && value) {
                                Dialogs.showSnackBar(
                                    context, 'Image Successfully Saved!');
                              }
                            });
                          },
                          name: 'Save Image',
                          icon: const Icon(
                            Icons.upload,
                            color: Colors.black,
                          ))
                      : const SizedBox.shrink(),
              messagesModel.type == Type.voice
                  ? const SizedBox.shrink()
                  : Divider(
                      color: Colors.black,
                      endIndent: 30.w,
                      indent: 30.w,
                    ),
              if (messagesModel.type == Type.text)
                OptionItem(
                    onTap: () {
                      Navigator.pop(context);
                      Dialogs.showMessageDialog(context, messagesModel);
                    },
                    name: 'Edit Message',
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    )),
              OptionItem(
                  onTap: () async {
                    await ChatCubit.get(context).deleteMessage(messagesModel);
                    Navigator.pop(context);
                  },
                  name: 'Delete Message',
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
              OptionItem(
                  onTap: () {},
                  name:
                      'Send at: ${HelperFunctions.getMessageTime(context: context, time: messagesModel.sent)} ',
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.black,
                  )),
              OptionItem(
                  onTap: () {},
                  name: messagesModel.read == ""
                      ? 'read at: Not Seen Yet'
                      : "read at: ${HelperFunctions.getMessageTime(context: context, time: messagesModel.read)}",
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.green,
                  )),
            ],
          );
        });
  }
}
