import 'package:flutter/material.dart';
import 'package:kite/chat/ui/widgets/play_audio.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:kite/shared/constants/url_constants.dart';

class MessageTileWidget extends StatelessWidget {
  MessageTileWidget(
      {Key? key,
      required this.type,
      required this.isByUser,
      required this.message,
      required this.time,
      required this.isContinue})
      : super(key: key);
  String message;
  String time;
  bool isByUser;
  bool isContinue;
  String type;

  Widget showMessage(String type, String message) {
    print(type);
    if (type == "image") {
      return Image.network('$imgMsgUrl/${message}');
      // return Text("Hello");
    } else if (type == "audio") {
      // return PlayAudioFromFile(audioMsgUrl: '$audioMsgUrl/${message}');

      return Text(audioMsgUrl);
    } else {
      int length = message.split("\n").length;
      if (length > 10) {
        List<String> splitText = message.split("\n");
        String shrinkText = "";
        for (int i = 0; i <= 9; i++) {
          shrinkText += splitText[i];
          if (i != splitText.length - 1) {
            shrinkText += "\n";
          }
        }
        return TextRenderWidget(
            fullText: message, shrinkText: shrinkText.trim());
      } else {
        return Text(message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: isContinue ? 0.5.h : 1.5.h,
          bottom: 0.5.h,
          left: 1.w,
          right: 1.w),
      child: Row(
        mainAxisAlignment:
            isByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isByUser)
            SizedBox(
              width: 18.w,
            ),
          Flexible(
            child: Material(
              elevation: 3,
              color: isByUser
                  ? Colors.lightBlueAccent
                  : const Color.fromARGB(255, 236, 235, 235),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.sp)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: showMessage(type, message),
                    ),
                    // Text(message, style: TextStyle(fontSize: 16.sp))),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      time,
                      style: TextStyle(fontSize: 14.sp),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (!isByUser)
            SizedBox(
              width: 18.w,
            ),
        ],
      ),
    );
  }
}

class TextRenderWidget extends StatefulWidget {
  const TextRenderWidget(
      {super.key, required this.fullText, required this.shrinkText});
  final String fullText;
  final String shrinkText;

  @override
  State<TextRenderWidget> createState() => _TextRenderWidgetState();
}

class _TextRenderWidgetState extends State<TextRenderWidget> {
  String toRenderText = '';

  @override
  void initState() {
    super.initState();
    toRenderText = widget.shrinkText;
  }

  void shrink() {
    toRenderText = widget.shrinkText;
  }

  void grow() {
    toRenderText = widget.fullText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(toRenderText),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  if (toRenderText == widget.fullText) {
                    shrink();
                  } else {
                    grow();
                  }
                });
              },
              child: Text(
                toRenderText == widget.fullText ? "Show less" : "Show more",
                style: TextStyle(color: Colors.blue[700]),
              )),
        ),
      ],
    );
  }
}
