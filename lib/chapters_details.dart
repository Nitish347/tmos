import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tmos/pdf_viewer.dart';

import 'colors.dart';

class ChapterDetailsPopup extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final String pdfPath;
  final int index;

  const ChapterDetailsPopup({
    super.key,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.pdfPath,
    required this.index
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              // imagePath,
              "assets/bg.webp",
              height: 200.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "Chapter: ${index +1}",
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blueColor.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blueColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 20.sp,
              height: 1.5,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 80.h),
          SizedBox(
            height: 60.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                log(pdfPath.toString());
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFReaderScreen(pdfPath: pdfPath, title: "Chapter: ${index+1}", showChapters: true,)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blueColor,
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                'Read',
                style: TextStyle(fontSize: 20.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
