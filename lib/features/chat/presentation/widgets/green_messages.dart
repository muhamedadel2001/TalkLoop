import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/core/utilits/helper_functions.dart';
import 'package:chatapp/features/chat/manager/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/message_model.dart';

class GreenMessages extends StatefulWidget {
  final MessagesModel model;
  const GreenMessages({super.key, required this.model});

  @override
  State<GreenMessages> createState() => _GreenMessagesState();
}

class _GreenMessagesState extends State<GreenMessages> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  @override
  void initState() {
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event == PlayerState.playing;
        });
      }
    });
    audioPlayer.onDurationChanged.listen((newDurition) {
      if (mounted) {
        setState(() {
          duration = newDurition;
        });
      }
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });
    audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          position = Duration.zero;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 10.w,
            ),
            if (widget.model.read.isNotEmpty)
              Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 18.sp,
              ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              HelperFunctions.getFormatTime(
                  context: context, time: widget.model.sent),
              style: TextStyle(fontSize: 13.sp, color: Colors.white),
            ),
          ],
        ),
        Flexible(
          child: Container(
              margin: widget.model.type == Type.image
                  ? EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h)
                  : EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightGreen),
                  color: const Color.fromARGB(255, 218, 255, 176),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.sp),
                      topRight: Radius.circular(30.sp),
                      bottomLeft: Radius.circular(30.sp))),
              padding: widget.model.type == Type.text
                  ? EdgeInsets.all(18.sp)
                  : EdgeInsets.all(8.sp),
              child: widget.model.type == Type.text
                  ? Text(
                      widget.model.msg,
                      style: TextStyle(color: Colors.black, fontSize: 15.sp),
                    )
                  : widget.model.type == Type.image
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15.sp),
                          child:
                          CachedNetworkImage(
                        imageUrl: widget.model.msg,
                        placeholder: (context, url) => const CircularProgressIndicator(color: Colors.grey,),
                        errorWidget: (context, url, error) {

                          return const Icon(Icons.image);
                        }),
                          )
                      : Column(
                          children: [
                            Slider(
                                inactiveColor: Colors.grey,
                                thumbColor: Colors.grey,
                                activeColor: Colors.white,
                                min: 0,
                                max: duration.inSeconds.toDouble(),
                                value: position.inSeconds.toDouble(),
                                onChanged: (value) async {
                                  final position =
                                      Duration(seconds: value.toInt());
                                  if (audioPlayer.state ==
                                      PlayerState.completed) {
                                    await audioPlayer.seek(position);
                                    await audioPlayer
                                        .play(UrlSource(widget.model.msg));
                                  }
                                  await audioPlayer.seek(position);
                                  await audioPlayer.resume();
                                }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ChatCubit.get(context).formatTime(position),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  ChatCubit.get(context)
                                      .formatTime(duration - position),
                                  style: const TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 20.sp,
                              child: IconButton(
                                  color: Colors.white,
                                  onPressed: () async {
                                    if (isPlaying) {
                                      await audioPlayer.pause();
                                    } else {
                                      await audioPlayer
                                          .play(UrlSource(widget.model.msg));
                                    }
                                  },
                                  icon: Icon(isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow)),
                            )
                          ],
                        )),
        ),
      ],
    );
  }
}
