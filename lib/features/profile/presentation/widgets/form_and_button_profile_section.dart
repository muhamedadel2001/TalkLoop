import 'package:chatapp/core/utilits/dialogs.dart';
import 'package:chatapp/features/home/data/chat_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../home/manager/home_cubit.dart';

class FormAndButtonProfileSection extends StatelessWidget {
  final ChatUserModel chatUserModel;
  const FormAndButtonProfileSection({super.key, required this.chatUserModel});
  @override
  Widget build(BuildContext context) {
    return Form(
      key: HomeCubit.get(context).formKey,
      child: Column(
        children: [
          CustomTextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return ' name can\'t  be empty';
              }
              return null;
            },
            onSaved: (val) {
              HomeCubit.me.name = val ?? '';
              return null;
            },
            initialValue: chatUserModel.name,
            labelName: 'Name',
            prefixIcon: Icons.person,
          ),
          SizedBox(
            height: 20.h,
          ),
          CustomTextFormField(
            onSaved: (val) {
              HomeCubit.me.about = val ?? '';
              return null;
            },
            initialValue: chatUserModel.about,
            labelName: 'about',
            prefixIcon: Icons.info_outline,
          ),
          SizedBox(
            height: 30.h,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.grey.shade700,
                padding: EdgeInsets.all(15.sp),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.sp))),
            onPressed: () {
              if (HomeCubit.get(context).formKey.currentState!.validate()) {
                HomeCubit.get(context).formKey.currentState!.save();
                HomeCubit.get(context).updateData().then((value) {
                  Dialogs.showSnackBar(
                    context,
                    'Profile Updated Successfully !',
                  );
                });
              }
            },
            icon: const Icon(Icons.edit,color: Colors.white,),
            label: Text(
              'Update',
              style: TextStyle(fontSize: 20.sp,color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
