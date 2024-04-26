import 'package:chatapp/core/utilits/dialogs.dart';
import 'package:chatapp/core/utilits/screens.dart' as screens;
import 'package:chatapp/features/home/manager/home_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);
  AuthCubit() : super(AuthInitial());
  static FirebaseAuth auth = FirebaseAuth.instance;
  Future signInWithGoogle(BuildContext context) async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(AuthFailed());
        return Dialogs.showSnackBar(context, 'Something Went Wrong');
      } else {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        emit(AuthSuccess());
        auth.signInWithCredential(credential);

        await auth.signInWithCredential(credential);

        await HomeCubit.get(context).getSelfInfo(context);

        Navigator.pushNamedAndRemoveUntil(
            context, screens.homeScreen, (route) => false);
      }
    } catch (error) {

    }
  }

  Future signOut() async {
    await auth.signOut();
    await GoogleSignIn().signOut();
  }
}
