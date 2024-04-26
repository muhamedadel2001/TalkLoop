import 'package:chatapp/core/utilits/colors.dart';
import 'package:chatapp/features/auth/presentation/widgets/log_in_body_screen.dart';
import 'package:flutter/material.dart';
class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor.withOpacity(0.5),
      body:const LogInBodyScreen()
    );
  }
}
