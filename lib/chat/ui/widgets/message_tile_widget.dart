

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MessageTileWidget extends StatelessWidget {
   MessageTileWidget({Key? key, required this.isByUser, required this.message, required this.time,required this.isContinue}) : super(key: key);
  String message;
  String time;
  bool isByUser;
  bool isContinue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top:isContinue?0.5.h:1.5.h,bottom: 0.5.h,left: 1.w,right: 1.w),
      child: Row(
        mainAxisAlignment: isByUser?
        MainAxisAlignment.end:
        MainAxisAlignment.start
        ,
        children: [
          if(isByUser)
          SizedBox(width: 18.w,),
          Flexible(
            child: Material(
              elevation: 3,
              color:isByUser? Colors.lightBlueAccent:const Color.fromARGB(255, 236, 235, 235),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.sp)
              ),
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal:4.w,vertical: 1.h),
                child: Row(
                  children: [
                    Expanded(child: Text(message,style:TextStyle(fontSize: 16.sp))),
                    SizedBox(width: 2.w,),
                    Text(time,style: TextStyle(fontSize: 14.sp),)
                  ],
                ),
              ),
            ),
          ),
          if(!isByUser)
          SizedBox(width: 18.w,),
        ],
      ),
    );
  }
}