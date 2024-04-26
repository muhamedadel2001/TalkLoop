import 'package:chatapp/core/utilits/api.dart';
import 'package:chatapp/core/utilits/app_router.dart';
import 'package:chatapp/core/utilits/bloc_observer.dart';
import 'package:chatapp/features/chat/manager/chat_cubit.dart';
import 'package:chatapp/features/home/manager/home_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/utilits/dio.dart';
import 'core/utilits/firebase_options.dart';
import 'features/auth/manager/auth_cubit.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Apis.inatializeNotification();
  await MyDio.dioInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ChatCubit()),
            BlocProvider(create: (context) => AuthCubit()),
            BlocProvider(
                create: (context) => HomeCubit()..getSelfInfo(context)),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'First Method',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            onGenerateRoute: AppRouter.router.onGenerateRoute,
          ),
        );
      },
    );
  }
}
