import 'package:chatapp/core/utilits/colors.dart';
import 'package:chatapp/features/chat/data/message_model.dart';
import 'package:chatapp/features/chat/manager/chat_cubit.dart';
import 'package:chatapp/features/home/manager/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dialogs {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.grey.shade500,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showMessageDialog(
      BuildContext context, MessagesModel messagesModel) {
    String updateMessage = messagesModel.msg;
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.sp)),
              title: Row(
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.grey,
                    size: 28.sp,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'Update Message',
                    style: TextStyle(color: Colors.black, fontSize: 20.sp),
                  )
                ],
              ),
              content: TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                onChanged: (value) {
                  updateMessage = value;
                },
                initialValue: updateMessage,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.sp)),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.sp))),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'cancel',
                    style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    await ChatCubit.get(context)
                        .updateMessage(messagesModel, updateMessage);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.green, fontSize: 15.sp),
                  ),
                ),
              ],
            ));
  }

  static void showDialogAddUsers(
    BuildContext context,
  ) {
    String email = '';
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.sp)),
              title: Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.grey,
                    size: 28.sp,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    ' Add User',
                    style: TextStyle(color: Colors.black, fontSize: 20.sp),
                  )
                ],
              ),
              content: TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.sp)),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.sp))),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'cancel',
                    style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (email.isNotEmpty) {
                      await HomeCubit.get(context).addUser(email,context).then((value) {

                      });
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.green, fontSize: 15.sp),
                  ),
                ),
              ],
            ));
  }

  static progressBar(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            color: secondColor,
          ));
        });
  }
}
