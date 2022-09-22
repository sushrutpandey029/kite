import 'package:flutter/material.dart';
import 'package:kite/shared/constants/textstyle.dart';
import 'package:kite/shared/ui/widgets/custom_app_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../shared/constants/color_gradient.dart';

class NotificationSoundsPage extends StatefulWidget {
  const NotificationSoundsPage({Key? key}) : super(key: key);

  @override
  State<NotificationSoundsPage> createState() => _NotificationSoundsPageState();
}

class _NotificationSoundsPageState extends State<NotificationSoundsPage> {
  List titles = <String>[
    'Notification sound',
    'Vibrate',
    'Popup notification',
    'Notification sound',
    'Vibrate',
    'Popup notification',
    'Ringtone sound',
    'Vibration',
    'Ring and vibrate'
  ];
  List listValue = <bool>[
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  void reset(List list) {
    for (int i = 0; i < list.length; i++) {
      if (list.elementAt(i) == true) {
        list[i] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notofication and Sound'),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: gradient1),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chat notification',
              style: blueText1,
            ),
            for (int index = 0; index < 3; index++)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(titles.elementAt(index)),
                value: listValue.elementAt(index),
                onChanged: (value) {
                  setState(() {
                    listValue[index] = value;
                  });
                },
              ),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
            Text(
              'Group notification',
              style: blueText1,
            ),
            for (int index = 3; index < 6; index++)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(titles.elementAt(index)),
                value: listValue.elementAt(index),
                onChanged: (value) {
                  setState(() {
                    listValue[index] = value;
                  });
                },
              ),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
            Text(
              'Audio and Video Call notification',
              style: blueText1,
            ),
            for (int index = 6; index < 9; index++)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(titles.elementAt(index)),
                value: listValue.elementAt(index),
                onChanged: (value) {
                  setState(() {
                    listValue[index] = value;
                  });
                },
              ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                reset(listValue);
                setState(() {});
              },
              child: const Text(
                'Reset notification',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
