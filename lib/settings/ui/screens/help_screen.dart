import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:kite/shared/constants/textstyle.dart';
import 'package:kite/shared/ui/widgets/custom_app_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../web_search/ui/screen/web_view_screen.dart';
import '../../widget/setting_app_bar.dart';
import 'app_info_screen.dart';
import 'contact_us_screen.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SettingAppBar('Help'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactUsScreen()),
                    );
                  },
                  child: Text(
                    'Contact us',
                    style: text1,
                  )),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(
                      url: 'https://www.google.com/',
                      name: "Terms and Condition",
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Terms & Privacy Policy',
                  style: text1,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppInfoScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'App info',
                  style: text1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
