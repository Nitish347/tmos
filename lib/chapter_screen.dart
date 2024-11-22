import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tmos/utils.dart';
import 'package:tmos/widgets/grid_card.dart';

import 'chapters_details.dart';
import 'colors.dart';
import 'controller.dart';

class ChapterScreen extends StatelessWidget {

  final String part;

  ChapterScreen({super.key, required this.part});
  // List<Map<String, String>> allChapters = [];
  final controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    // if(controller.part.value ==0){
    //   allChapters = chapter1;
    // }else{
    //   allChapters = chapter2;
    // }
    // final chapters = List.generate(
    //   allChapters.length,
    //   (index) => {
    //     'title': allChapters[index]["name"],
    //     'image': allChapters[index]["img"],
    //     'description': allChapters[index]["text"],
    //     'path': allChapters[index]["path"]
    //   },
    // );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text('$part Chapters',style: GoogleFonts.poppins(color: Colors.white),),
        backgroundColor: AppColors.blueColor,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1/1.4
        ),
        itemCount: controller.bookPart.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: OpenContainer(
              closedElevation: 4,
              closedColor: Colors.white,
              closedBuilder: (context, action) {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.white.withOpacity(0.95),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => ChapterDetailsPopup(
                        title: controller.bookPart[index]['name'] ?? "",
                        imagePath:  controller.bookPart[index]['img'] ?? "",
                        description:  controller.bookPart[index]['text'] ?? "",
                        pdfPath:  controller.bookPart[index]["path"] ?? "", index: index,
                      ),
                    );
                  },
                  child: GridCard(
                    title:  controller.bookPart[index]['name']!,
                    imagePath:  controller.bookPart[index]['img']!, index: index,
                  ),
                );
              },
              openBuilder: (_, __) {
                // This won't be triggered as we replaced with GestureDetector
                return const SizedBox.shrink();
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        },
      ),
    );
  }
}
