import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:ffi';

class PlayAudioFromFile extends StatefulWidget {
  const PlayAudioFromFile({super.key, required this.audioMsgUrl});
  final String audioMsgUrl;

  @override
  State<PlayAudioFromFile> createState() => _PlayAudioFromFileState();
}

class _PlayAudioFromFileState extends State<PlayAudioFromFile> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration();
  Duration position = Duration();

  String formatTime(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    super.initState();
    setAudio();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode((ReleaseMode.LOOP));
    audioPlayer.setUrl(widget.audioMsgUrl);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 50,
        width: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);

                  await audioPlayer.resume();
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position)),
                Text(formatTime(duration - position)),
              ],
            ),
            IconButton(
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    await audioPlayer.resume();
                  }
                },
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow)),
            // IconButton(
            //     icon: Icon(Icons.play_arrow),
            //     onPressed: () {
            //       audio.play(widget.audioMsgUrl);
            //     }),
            // IconButton(
            //     icon: Icon(Icons.pause),
            //     onPressed: () {
            //       audio.pause();
            //     }),
            // IconButton(
            //     icon: Icon(Icons.stop),
            //     onPressed: () {
            //       audio.stop();
            //     }),
          ],
        ),
      ),
    );
  }

  /// Compulsory
  // AudioPlayer audioPlayer = AudioPlayer();
  // PlayerState audioPlayerState = PlayerState.PAUSED;

  // /// Optional
  // int timeProgress = 0;
  // int audioDuration = 0;

  // /// Optional
  // Widget slider() {
  //   return Container(
  //     width: 300.0,
  //     child: Slider.adaptive(
  //         value: timeProgress.toDouble(),
  //         max: audioDuration.toDouble(),
  //         onChanged: (value) {
  //           seekToSec(value.toInt());
  //         }),
  //   );
  // }

  // @override
  // void initState() {
  //   super.initState();

  //   /// Compulsory
  //   audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
  //     setState(() {
  //       audioPlayerState = state;
  //     });
  //   });

  //   /// Optional
  //   audioPlayer.setUrl(widget
  //       .audioMsgUrl); // Triggers the onDurationChanged listener and sets the max duration string
  //   audioPlayer.onDurationChanged.listen((Duration duration) {
  //     setState(() {
  //       audioDuration = duration.inSeconds;
  //     });
  //   });
  //   audioPlayer.onAudioPositionChanged.listen((Duration position) async {
  //     setState(() {
  //       timeProgress = position.inSeconds;
  //     });
  //   });
  // }

  // /// Compulsory
  // @override
  // void dispose() {
  //   audioPlayer.release();
  //   audioPlayer.dispose();
  //   super.dispose();
  // }

  // /// Compulsory
  // playMusic() async {
  //   // Add the parameter "isLocal: true" if you want to access a local file
  //   await audioPlayer.play(widget.audioMsgUrl);
  // }

  // /// Compulsory
  // pauseMusic() async {
  //   await audioPlayer.pause();
  // }

  // /// Optional
  // void seekToSec(int sec) {
  //   Duration newPos = Duration(seconds: sec);
  //   audioPlayer
  //       .seek(newPos); // Jumps to the given position within the audio file
  // }

  // /// Optional
  // String getTimeString(int seconds) {
  //   String minuteString =
  //       '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
  //   String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
  //   return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Container(
  //         alignment: Alignment.center,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             /// Compulsory
  //             IconButton(
  //                 iconSize: 20,
  //                 onPressed: () {
  //                   audioPlayerState == PlayerState.PLAYING
  //                       ? pauseMusic()
  //                       : playMusic();
  //                 },
  //                 icon: Icon(audioPlayerState == PlayerState.PLAYING
  //                     ? Icons.pause_rounded
  //                     : Icons.play_arrow_rounded)),

  //             /// Optional
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(getTimeString(timeProgress)),
  //                 SizedBox(width: 10),
  //                 Container(width: 150, child: slider()),
  //                 SizedBox(width: 10),
  //                 Text(getTimeString(audioDuration))
  //               ],
  //             )
  //           ],
  //         )),
  //   );
  // }
}
