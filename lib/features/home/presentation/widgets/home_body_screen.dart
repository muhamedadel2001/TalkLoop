import 'package:chatapp/features/home/manager/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'list_view_item.dart';

class HomeBodyScreen extends StatefulWidget {
  const HomeBodyScreen({
    super.key,
  });

  @override
  State<HomeBodyScreen> createState() => _HomeBodyScreenState();
}

class _HomeBodyScreenState extends State<HomeBodyScreen> {
  @override
  void initState() {
    HomeCubit.get(context).fetchDataUser();
    HomeCubit.get(context).fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if(state is HomeLoadingData){
          return const Center(child: CircularProgressIndicator(color: Colors.grey,));
        }
        if (HomeCubit.get(context).myFriends.isEmpty) {
          return Center(
              child: Text(
            'No Friends Yet!',
            style: TextStyle(color: Colors.black, fontSize: 25.sp),
          ));
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListViewItem(
                          model: HomeCubit.get(context).isSearchging
                              ? HomeCubit.get(context).searchList[index]
                              : HomeCubit.get(context).models[index],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 5.h,
                        );
                      },
                      itemCount: HomeCubit.get(context).isSearchging
                          ? HomeCubit.get(context).searchList.length
                          : HomeCubit.get(context).models.length),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
