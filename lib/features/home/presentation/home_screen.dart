import 'package:chatapp/core/utilits/dialogs.dart';
import 'package:chatapp/features/home/manager/home_cubit.dart';
import 'package:chatapp/features/home/presentation/widgets/app_bar_section.dart';
import 'package:chatapp/features/home/presentation/widgets/home_body_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utilits/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (HomeCubit.firebaseAuth.currentUser != null) {
        if (message.toString().contains('resume')) {
          HomeCubit.get(context).updateLastSeen(true);
        }
        if (message.toString().contains('pause')) {
          HomeCubit.get(context).updateLastSeen(false);
        }
      }
      return Future.value(message);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if (HomeCubit.get(context).isSearchging) {
            HomeCubit.get(context).changeSearch();
          } else {
            return Future.value(true);
          }
          return Future.value(false);
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.grey.withOpacity(0.5),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Dialogs.showDialogAddUsers(context);
            },
          ),
          backgroundColor: mainColor.withOpacity(0.5),
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.h),
              child: const AppBarSection()),
          body: const HomeBodyScreen(),
        ),
      ),
    );
  }
}
