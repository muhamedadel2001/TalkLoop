part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}
class GetMessagesLoading extends ChatState {}
class GetMessagesSuccess extends ChatState {}
class GetMessagesFailed extends ChatState {}
class SendMessageSuccess extends ChatState {}
class GetLastMessage extends ChatState {}
class ChatEmojiChange extends ChatState {}
class Uploaded extends ChatState {}
class StopRecorded extends ChatState {}
class StartRecorded extends ChatState {}
class UploadedRecorded extends ChatState {}
class AudioPlayerDurationChanged extends ChatState {}
class AudioPlayerPositionChanged extends ChatState {}
class AudioPlayerOnComplete extends ChatState {}
class AudioPlayerChangeIcon extends ChatState {}
class DeleteMessageSuccess extends ChatState {}
class UpdateMessageSuccess extends ChatState {}
class ChangeLastActive extends ChatState {}

