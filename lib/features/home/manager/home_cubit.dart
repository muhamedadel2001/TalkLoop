import 'dart:async';
import 'dart:io';

import 'package:chatapp/core/utilits/api.dart';
import 'package:chatapp/core/utilits/dialogs.dart';
import 'package:chatapp/features/home/data/chat_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  static HomeCubit get(context) => BlocProvider.of<HomeCubit>(context);
  HomeCubit() : super(HomeInitial());
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final List<ChatUserModel> models = [];
  final List<ChatUserModel> models2 = [];
  final List<String> users = [];
  final List<ChatUserModel> searchList = [];
  final List myFriends = [];
  static late ChatUserModel me;
  GlobalKey<FormState> formKey = GlobalKey();
  bool isSearchging = false;
  void changeSearch() {
    isSearchging = !isSearchging;
    emit(HomeSearchChange());

  }


  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = ChatUserModel(
        name: firebaseAuth.currentUser!.displayName.toString(),
        id: firebaseAuth.currentUser!.uid,
        email: firebaseAuth.currentUser!.email.toString(),
        about: 'Hey iam using flutter',
        image: firebaseAuth.currentUser!.photoURL.toString(),
        createdAt: time,
        lastActive: time,
        isOnline: false,
        pushToken: '',
        friends: []);
    return await fireStore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid.toString())
        .set(chatUser.toJson());
  }

  static Future<bool> userExists() async {
    return (await fireStore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .get())
        .exists;
  }

  Future<void> fetchDataUser() async {
    await fireStore.collection('users')
      ..where('id', isEqualTo: firebaseAuth.currentUser!.uid)
          .snapshots()
          .listen((event) {
        fetchData();
      });
  }

  Future<void> fetchData() async {
    emit(HomeLoadingData());
    await getMyUserId();
    if (myFriends.isNotEmpty) {
      try {
        await fireStore
            .collection('users')
            .where('id', whereIn: myFriends)
            .snapshots()
            .listen((QuerySnapshot snapshot) {
          models.clear();
          snapshot.docs.forEach((DocumentSnapshot document) {
            final data = document.data() as Map<String, dynamic>;
            models.add(ChatUserModel.fromJson(data));
          });
          emit(HomeSuccessData());
        });
      } catch (e) {
        emit(HomeFailedData());

      }
    }
  }

  Future<void> getMyUserId() async {
    await fireStore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      myFriends.clear();
      for (String element in value['friends']) {
        myFriends.add(element);
      }

      emit(GetMyFriends());
    });
  }

  Future<void> addUser(String email, BuildContext context) async {
    await fireStore
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) async {
      QueryDocumentSnapshot<Map<String, dynamic>>? element;

      for (element in value.docs) {
        if (element.data().isNotEmpty) {}
      }
      if (element!.data().isNotEmpty &&
          element.data()['id'] != firebaseAuth.currentUser!.uid) {
        await fireStore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          'friends': FieldValue.arrayUnion([element.data()['id']])
        });
        fetchData();
      }
    }).catchError((error) {
      return Dialogs.showSnackBar(context, 'user not exist');
    });
  }

  Future<void> getSelfInfo(BuildContext context) async {
    await fireStore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUserModel.fromJson(user.data()!);
        await Apis.getFirebaseMessagingToken();
        updateLastSeen(true);
      } else {
        createUser().then((value) {
          getSelfInfo(context);
        });
      }
    });
  }

  Future<void> updateData() async {
    await fireStore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({'name': me.name, 'about': me.about});
  }

  void searchUser(String val) {
    searchList.clear();
    for (var i in models) {
      if (i.name.toLowerCase().contains(val.toLowerCase()) ||
          i.email.toLowerCase().contains(val.toLowerCase())) {
        searchList.add(i);
      }
      emit(HomeSearchUser());
    }
  }

  Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('_').last;
    final ref = firebaseStorage
        .ref()
        .child('profile_pictures/${firebaseAuth.currentUser!.uid}');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {});
    me.image = await ref.getDownloadURL();
    await fireStore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({'image': me.image});
  }

  Future<void> updateLastSeen(bool lastSeen) async {
    await fireStore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'isOnline': lastSeen,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      'pushToken': me.pushToken
    });

    emit(ChangeLastActive());
  }

  Future<void> getSelfUser(ChatUserModel chatUserModel) async {
    await fireStore
        .collection('users')
        .where('id', isEqualTo: chatUserModel.id)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      models2.clear();
      snapshot.docs.forEach((DocumentSnapshot document) {
        final data = document.data() as Map<String, dynamic>;
        models2.add(ChatUserModel.fromJson(data));
      });
      emit(HomeSuccessData());
    });
  }
}
