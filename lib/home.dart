import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tmos/colors.dart';
import 'package:tmos/pdf_viewer.dart';
import 'package:tmos/utils.dart';
import 'package:tmos/widgets/drawer.dart';
import 'package:tmos/widgets/grid_card.dart';
import 'package:tmos/widgets/home_card.dart';

import 'chapter_screen.dart';
import 'chapters_details.dart';
import 'controller.dart';

class PartSelectionScreen extends StatelessWidget {
   PartSelectionScreen({super.key});
final controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    final parts = [
      {'title': 'Part 1', 'image': 'assets/part1.png'},
      {'title': 'Part 2', 'image': 'assets/part2.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: AppColors.blueColor,
        title: Text(
          "The Melange of Success",
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      drawer: BookDrawer(),
      body: Container(
        height: 1.sh,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Spacer(), // Push the grid to the bottom
              Card(
                color: Colors.white.withOpacity(0.8),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ListTile(
                  onTap: (){
                    Get.to(()=>PDFReaderScreen(pdfPath: about, title: "About the Author",showChapters: false,));
                  },
                  leading: const CircleAvatar(
                    radius: 25,
                  ),
                  title: Text(
                    "Praveen Soni",
                    style: TextStyle(
                      color: AppColors.blueColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    "More about Praveen Soni",
                    style: TextStyle(
                      color: AppColors.blueColor.withOpacity(0.7),
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: parts.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: OpenContainer(
                      closedElevation: 4,
                      closedColor: Colors.white,
                      closedBuilder: (context, action) {
                        return HomeCard(
                          title: parts[index]['title']!,
                          imagePath: parts[index]['image']!,
                        );
                      },
                      openBuilder: (context, action) {
                        controller.onSelectPart(index);
                        return ChapterScreen(
                          part: parts[index]['title']!,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 500),
                    ),
                  );
                },
              ),
              // SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}






