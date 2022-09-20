import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kite/authentication/provider/auth_provider.dart';
import 'package:kite/shared/constants/color_gradient.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../shared/constants/textstyle.dart';
import '../../../shared/ui/widgets/custom_elevated_button_widget.dart';

class SetProfilePage extends StatefulWidget {
  const SetProfilePage({Key? key}) : super(key: key);

  @override
  State<SetProfilePage> createState() => _SetProfilePageState();
}

class _SetProfilePageState extends State<SetProfilePage> {
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  DateTime? dob;
  String? imagePath;
  bool _showBottomSheet = false;

  Future<void> _setProfilePicture(bool isCamera) async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = isCamera
        ? await picker.pickImage(source: ImageSource.camera)
        : await picker.pickImage(source: ImageSource.gallery);
    imagePath = xFile?.path;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _showBottomSheet
          ? BottomSheet(
              elevation: 10,
              // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onClosing: () {},
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(204, 60, 60, 60),
                            offset: Offset(0, -4),
                            blurRadius: 15)
                      ]),
                  height: 18.h,
                  padding: EdgeInsets.only(top: 2.5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            child: Material(
                                elevation: 10,
                                shape: const CircleBorder(),
                                child: Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: IconButton(
                                      iconSize: 25.sp,
                                      color: Colors.blueAccent,
                                      onPressed: () {
                                        setState(() {
                                          _showBottomSheet = !_showBottomSheet;
                                        });
                                        _setProfilePicture(true);
                                      },
                                      icon: const Icon(Icons.camera_alt)),
                                )),
                          ),
                          const Text('Camera')
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            child: Material(
                              elevation: 10,
                              shape: const CircleBorder(),
                              child: Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: IconButton(
                                    iconSize: 25.sp,
                                    onPressed: () {
                                      setState(() {
                                        _showBottomSheet = !_showBottomSheet;
                                      });
                                      _setProfilePicture(false);
                                    },
                                    icon: Image.asset(
                                        'assets/images/gallery.png'),
                                  )),
                            ),
                          ),
                          const Text('Gallery')
                        ],
                      ),
                    ],
                  ),
                );
              })
          : null,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Column(
            children: [
              Text(
                'Set Profile',
                style: boldHeading2,
              ),
              Padding(
                padding: EdgeInsets.only(top: 6.h, bottom: 2.h),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _showBottomSheet = !_showBottomSheet;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 30.w,
                        decoration: BoxDecoration(
                            gradient: gradient1,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: const [
                              BoxShadow(offset: Offset(2, 2), blurRadius: 10)
                            ]),
                        child: imagePath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  File(imagePath!),
                                  fit: BoxFit.cover,
                                  height: 15.h,
                                ))
                            : Image.asset('assets/images/set-profile.png'),
                      ),
                      Material(
                          elevation: 10,
                          shape: const CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(10.sp),
                            child: const Icon(Icons.camera_alt_outlined),
                          ))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 2.h,
                ),
                child: TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'Username:',
                    suffixIcon: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 2.h,
                ),
                child: TextField(
                  controller: _bio,
                  decoration: const InputDecoration(
                    labelText: 'Bio:',
                    suffixIcon: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 2.h,
                ),
                child: TextField(
                  controller: _dob,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'DOB:',
                      border: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2)),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2)),
                      suffixIcon: IconButton(
                          color: Colors.black,
                          onPressed: () async {
                            dob = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year - 100),
                                lastDate: DateTime.now());
                            if (dob != null) {
                              _dob.text =
                                  "${dob!.day}/${dob!.month}/${dob!.year}";
                            }
                          },
                          icon: const Icon(Icons.edit))),
                ),
              ),
              const Text(
                  'Your Details are end-to-end encrypted. Any updates and changes will be visible to your contacts. Know more.'),
              const Spacer(),
              if (context.watch<AuthProvider>().isLoading)
                LinearProgressIndicator(
                  minHeight: .7.h,
                ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: CustomElevatedButton(
                  onPressed: () {
                    context.read<AuthProvider>().joinUserModel.userName =
                        _name.text;
                    context.read<AuthProvider>().joinUserModel.userBio =
                        _bio.text;
                    if (dob != null) {
                      context.read<AuthProvider>().joinUserModel.userDob = dob!;
                    }
                    context.read<AuthProvider>().joinUserModel.userImage =
                        imagePath!;
                    context.read<AuthProvider>().joinUser(context);
                  },
                  width: 70.w,
                  child: Text(
                    'Save',
                    style: text1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
