import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tmos/colors.dart';

import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 1000), () {
      Get.off(()=>PartSelectionScreen());

    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Color(0xff002060),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

               Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: ClipRRect(
                   borderRadius: BorderRadius.circular(20),
                   child: Image.asset(
                    "assets/final cover page.PNG",
                   fit: BoxFit.fitHeight,
                    height: h*0.65,
                                 ),
                 ),
               )


            ],
          ),
        ),
      ),
    );
  }
}
