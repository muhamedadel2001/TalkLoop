import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatapp/core/utilits/screens.dart' as screens;

import '../../../../core/utilits/colors.dart';
import '../../manager/home_cubit.dart';

class AppBarSection extends StatefulWidget {
  const AppBarSection({
    super.key,
  });

  @override
  State<AppBarSection> createState() => _AppBarSectionState();
}

class _AppBarSectionState extends State<AppBarSection> {
  late HomeCubit cubit;

  @override
  void initState() {
    cubit = HomeCubit.get(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return AppBar(
          backgroundColor: mainColor.withOpacity(0.5),
          leading: const Icon(Icons.home, color: Colors.white),
          centerTitle: true,
          title: cubit.isSearchging
              ? TextField(
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Email,name..'),
                  onChanged: (val) {
                    cubit.searchUser(val);
                  },
                )
              : const Text(
                  'Chats',
                  style: TextStyle(color: Colors.white),
                ),
          actions: [
            IconButton(
                onPressed: () {
                  cubit.changeSearch();
                },
                icon: Icon(
                  cubit.isSearchging ? Icons.cancel : Icons.search,
                  color: Colors.white,
                )),
            SizedBox(
              width: 20.w,
            ),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, screens.profileScreen,
                      arguments: HomeCubit.me);
                },
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                )),
            SizedBox(
              width: 8.w,
            )
          ],
        );
      },
    );
  }
}
