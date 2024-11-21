import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tmos/colors.dart';
import 'package:tmos/pdf_viewer.dart';
import 'package:tmos/utils.dart';

import '../chapter_screen.dart';
import '../controller.dart';

class BookDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Controller());
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        color: Colors.transparent, // Light blue background for the drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 40.h,
            ),
            Container(
              color: AppColors.blueColor, // Blue header
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The Melange of Success',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Praveen Soni",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),

            _buildDrawerItem(
              context,
              icon: Icons.auto_stories,
              label: 'Part 1',
              onTap: () {
                controller.part.value = 0;
             Get.to(()=>ChapterScreen(part: "Part 1",));
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.auto_stories,
              label: 'Part 2',
              onTap: () {
                controller.part.value = 1;
                Get.to(()=>ChapterScreen(part: "Part 2",));
              },
            ),
            const Divider(color: AppColors.blueColor,),
            _buildDrawerItem(
              context,
              icon: Icons.book,
              label: 'Preface',
              onTap: () {
                controller.part.value = 2;
                Get.to(()=>PDFReaderScreen(pdfPath: preface,));
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.bookmark,
              label: 'Acknowledgement',
              onTap: () {  controller.part.value = 2;
                Get.to(()=>PDFReaderScreen(pdfPath: acknowledgement,));
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.person,
              label: 'About the Author',
              onTap: () {  controller.part.value = 2;
                Get.to(()=>PDFReaderScreen(pdfPath: about,));
              },
            ),

            Divider(color: AppColors.blueColor,),
            _buildDrawerItem(
              context,
              icon: Icons.copy,
              label: 'Get Copy',
            ),
            _buildDrawerItem(
              context,
              icon: Icons.local_shipping,
              label: 'Get Physical Copy',
              onTap: () {
                // Navigate to Get Physical Copy page or functionality
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.book,
              label: 'Get on Kindle',
              onTap: () {
                // Navigate to Get on Kindle page or functionality
              },
            ),
            Divider(color: AppColors.blueColor,),
            _buildDrawerItem(
              context,
              icon: Icons.share,
              label: 'Share',
              onTap: () {
                // Share functionality
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.video_library,
              label: 'Official Launch Video',
              onTap: () {
                // Play the launch video
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.star_rate,
              label: 'Rate Us',
              onTap: () {
                // Redirect to rating functionality
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.mail,
              label: 'Mail Us',
              onTap: () {
                // Open mail client
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.blueColor,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(fontSize: 16.sp),
      ),
      onTap: onTap,
      hoverColor: Colors.blue.shade100, // Hover effect
      horizontalTitleGap: 10.w,
    );
  }
}
