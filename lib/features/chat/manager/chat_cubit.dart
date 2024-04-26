import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatapp/core/utilits/api.dart';
import 'package:chatapp/features/chat/data/message_model.dart';
import 'package:chatapp/features/home/data/chat_user_model.dart';
import 'package:chatapp/features/home/manager/home_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:chatapp/features/chat/data/message_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  static ChatCubit get(context) => BlocProvider.of<ChatCubit>(context);
  ChatCubit() : super(ChatInitial());
  final TextEditingController textEditingController = TextEditingController();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final List<MessagesModel> messages = [];
  String lastMessage = '';
  String checkIfRead = '';
  String lastSent = '';
  String dataType = '';
  bool isUpload = false;
  bool chatImoji = false;
  bool isRecord = false;
  final record = AudioRecorder();
  String path = '';
  String url = '';
  late MessagesModel messagesModel;
  String getConversationId(String id) =>
      firebaseAuth.currentUser!.uid.hashCode <= id.hashCode
          ? "${firebaseAuth.currentUser!.uid}_$id"
          : "${id}_${firebaseAuth.currentUser!.uid}";
  void checkEmoji() {
    chatImoji = !chatImoji;
    emit(ChatEmojiChange());
  }

  void checkUploading(bool upload) {
    isUpload = upload;
    emit(Uploaded());
  }

  Future<void> getAllMessage(ChatUserModel chatUserModel) async {
    emit(GetMessagesLoading());
    try {
      await fireStore
          .collection("chats/${getConversationId(chatUserModel.id)}/messages/")
          .orderBy('sent', descending: true)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        messages.clear();
        snapshot.docs.forEach((DocumentSnapshot document) {
          final data = document.data() as Map<String, dynamic>;
          messages.add(MessagesModel.fromJson(json: data));
        });
        emit(GetMessagesSuccess());
      });
    } catch (e) {
      emit(GetMessagesFailed());
      print('error is $e');
    }
  }

  Future<void> sendMessage(
      ChatUserModel chatUserModel, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final MessagesModel model = MessagesModel(
        firebaseAuth.currentUser!.uid, msg, '', time, chatUserModel.id, type);
    final ref = fireStore
        .collection("chats/${getConversationId(chatUserModel.id)}/messages/");
    await ref.doc(time).set(model.toJson()).then((value) {
      Apis.sendNotification(chatUserModel, type == Type.text ? msg : 'image');
    });
  }

  Future<void> sendFirstMessage(ChatUserModel chatUserModel, String msg,
      Type type, BuildContext context) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final MessagesModel model = MessagesModel(
        firebaseAuth.currentUser!.uid, msg, '', time, chatUserModel.id, type);
    final ref = fireStore
        .collection("chats/${getConversationId(chatUserModel.id)}/messages/");
    await ref.doc(time).set(model.toJson()).then((value) async {
      Apis.sendNotification(chatUserModel, type == Type.text ? msg : 'image');
      await fireStore.collection('users').doc(chatUserModel.id).update({
        'friends': FieldValue.arrayUnion([firebaseAuth.currentUser!.uid])
      });
      await HomeCubit.get(context).fetchData();
    });
  }

  Future<void> updateMessageRead(MessagesModel messagesModel) async {
    await fireStore
        .collection(
            "chats/${getConversationId(messagesModel.fromId)}/messages/")
        .doc(messagesModel.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  Future<void> deleteMessage(MessagesModel messagesModel) async {
    await fireStore
        .collection("chats/${getConversationId(messagesModel.toId)}/messages/")
        .doc(messagesModel.sent)
        .delete();
    if (messagesModel.type == Type.image || messagesModel.type == Type.voice) {
      await firebaseStorage.refFromURL(messagesModel.msg).delete();
    }
    ;
    emit(DeleteMessageSuccess());
  }

  Future<void> updateMessage(MessagesModel messagesModel, String msg) async {
    await fireStore
        .collection("chats/${getConversationId(messagesModel.toId)}/messages/")
        .doc(messagesModel.sent)
        .update({"msg": msg});

    emit(DeleteMessageSuccess());
  }

  Future<void> getLastMessage(ChatUserModel chatUserModel) async {
    var data;
    await fireStore
        .collection("chats/${getConversationId(chatUserModel.id)}/messages/")
        .limit(1)
        .orderBy('sent', descending: true)
        .snapshots()
        .listen((event) {
      event.docs.forEach((DocumentSnapshot document) {
        if (document.exists) {
          data = document.data() as Map<String, dynamic>;
        }
      });
      if (data != null) {
        lastSent = data['sent'];
        dataType = data['type'];
        lastMessage = data['msg'];
        checkIfRead = data['read'];
        if (data['read'] == '' &&
            data['fromId'] != firebaseAuth.currentUser!.uid) {
          checkIfRead = 'sent';
        } else {
          checkIfRead = '';
        }
        emit(GetLastMessage());
      }
    });
  }

  Future<void> sentChatImage(ChatUserModel userModel, File file) async {
    final ext = file.path.split('.').last;
    final ref = firebaseStorage.ref().child(
        'iamges/${getConversationId(userModel.id)}/${DateTime.now().millisecondsSinceEpoch}.${ext}');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {});
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(userModel, imageUrl, Type.image);
  }
  /*Future<void> sentChatVoice(ChatUserModel userModel, File file) async {
    final ext = file.path.split('.').last;
    final ref = firebaseStorage.ref().child(
        'voices/${getConversationId(userModel.id)}/${DateTime.now().millisecondsSinceEpoch}.${ext}');
    await ref
        .putFile(file, SettableMetadata(contentType: 'voice/$ext'))
        .then((p0) {});
    final voiceUrl = await ref.getDownloadURL();
    await sendMessage(userModel, voiceUrl, Type.voice);
  }*/

  startRecord() async {
    final location = await getApplicationDocumentsDirectory();
    String name = const Uuid().v1();
    if (await record.hasPermission()) {
      await record.start(const RecordConfig(),
          path: location.path + name + '.m4a');
      isRecord = true;
      emit(StartRecorded());
    }
    print('start record');
  }

  stopRecord() async {
    String? finalPath = await record.stop();
    path = finalPath!;
    isRecord = false;
    emit(StopRecorded());
    print('path is ${path}');
    print('stop recorded');
  }

  upload(ChatUserModel chatUserModel) async {
    final ext = path.split('.').last;
    final ref = firebaseStorage.ref().child(
        'voices/${getConversationId(chatUserModel.id)}/${DateTime.now().millisecondsSinceEpoch}.${ext}');
    await ref.putFile(File(path), SettableMetadata(contentType: 'voice/$ext'));
    final voiceUrl = await ref.getDownloadURL();
    url = voiceUrl;
    emit(UploadedRecorded());
    print('uploaded');
    sendMessage(chatUserModel, url, Type.voice);
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}
