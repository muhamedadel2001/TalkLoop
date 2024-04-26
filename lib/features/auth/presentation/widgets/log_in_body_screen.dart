import 'package:chatapp/features/auth/manager/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utilits/colors.dart';

class LogInBodyScreen extends StatelessWidget {
  const LogInBodyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 60.h),
              child: Center(
                child: SizedBox(
                    width: 350.w,
                    height: 270.h,
                    child: Image.asset('assets/images/log.image.png')),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 280.h, left: 40.w, right: 40.w),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: secondColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.sp))),
                    onPressed: () {
                      AuthCubit.get(context).signInWithGoogle(context);
                    },
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 5.h),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/images/google.image.svg'),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Flexible(
                                  child: Text(
                                    'login with Google',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20.sp),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ))),
          ],
        ),
      ),
    );
  }
}
