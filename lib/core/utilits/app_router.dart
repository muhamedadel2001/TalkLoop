import 'package:chatapp/core/utilits/screens.dart' as screens;
import 'package:chatapp/features/auth/presentation/log_in_screen.dart';
import 'package:chatapp/features/chat/presentation/main_chat_screen.dart';
import 'package:chatapp/features/home/data/chat_user_model.dart';
import 'package:chatapp/features/home/presentation/home_screen.dart';
import 'package:chatapp/features/profile/presentation/main_profile_screen.dart';
import 'package:chatapp/features/profile/presentation/widgets/view_profile_from_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final AppRouter router = AppRouter();
  late Widget startScreen;
  Route? onGenerateRoute(RouteSettings settings) {
    startScreen = FirebaseAuth.instance.currentUser == null
        ? const LogInScreen()
        : const HomeScreen();
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => startScreen);
      case screens.logScreen:
        return MaterialPageRoute(builder: (_) => const LogInScreen());
      case screens.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case screens.profileScreen:
        ChatUserModel chatUserModel = settings.arguments as ChatUserModel;
        return MaterialPageRoute(
            builder: (_) => MainProfileScreen(
                  chatUserModel: chatUserModel,
                ));
      case screens.chatScreen:
        ChatUserModel chatUserModel = settings.arguments as ChatUserModel;
        return MaterialPageRoute(
            builder: (_) => MainChatScreen(
                  model: chatUserModel,
                ));
      case screens.viewProfileScreen:
        ChatUserModel chatUserModel = settings.arguments as ChatUserModel;
        return MaterialPageRoute(
            builder: (_) => ViewProfileFromChat(
                  chatUserModel: chatUserModel,
                ));


      default:
        return null;
    }
  }
}
