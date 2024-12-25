import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tmos/colors.dart';
import 'package:tmos/pdf_viewer.dart';
import 'package:tmos/utils.dart';
import 'package:tmos/web_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../chapter_screen.dart';
import '../controller.dart';

class BookDrawer extends StatelessWidget {


  Future<void> launchGmail({
    required String recipient,
    String? subject,
    String? body,
  }) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: recipient,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );

    print(emailUri.toString()); // Debugging: Verify the email URI format

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication, // Ensure external app opens
      );
    } else {
      throw 'Could not launch $emailUri';
    }
  }


  Future<void> openGmailApp() async {
    const String gmailPackage = "com.google.android.gm";
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'praveensonifr@gmail.com',
      query: '',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        // Check if the device has the Gmail app
        await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // If not, fallback to opening Gmail by package name (Android-only)
        Uri gmailIntent = Uri(
          scheme: 'intent',
          path: 'mailto',
          queryParameters: {
            'package': gmailPackage,
          },
        );

        if (await canLaunchUrl(gmailIntent)) {
          await launchUrl(gmailIntent, mode: LaunchMode.externalApplication);
        } else {
          throw 'Gmail app is not installed or cannot be opened';
        }
      }
    } catch (e) {
      print('Error opening Gmail: $e');
    }
  }


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
                Get.to(()=>PDFReaderScreen(pdfPath: preface, title: "Preface", showChapters: false,));
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.bookmark,
              label: 'Acknowledgement',
              onTap: () {  controller.part.value = 2;
                Get.to(()=>PDFReaderScreen(pdfPath: acknowledgement, title: "Acknowledgement", showChapters: false,));
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.person,
              label: 'About the Author',
              onTap: () {  controller.part.value = 2;
                Get.to(()=>PDFReaderScreen(pdfPath: about, title: "About the Author", showChapters: false,));
              },
            ),

            Divider(color: AppColors.blueColor,),

            _buildDrawerItem(
              context,
              icon: Icons.local_shipping,
              label: 'Get Physical Copy',
              onTap: () {
                Get.to(()=>MyWebsite(url: "http://praveen.dotsforall.com/", title: "Get Physical Copy"));
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.book,
              label: 'Get on Kindle',
              onTap: () {
                // Navigate to Get on Kindle page or functionality
                Get.to(()=>MyWebsite(url: "https://www.amazon.in/MELANGE-SUCCESS-defeat-till-accepts-ebook/dp/B07Y7K51NQ/ref=mp_s_a_1_1?dchild=1&keywords=the+melange+of+success&qid=1595087310&sr=8-1", title: "Get Copy"));

              },
            ),
            // Divider(color: AppColors.blueColor,),
            // _buildDrawerItem(
            //   context,
            //   icon: Icons.share,
            //   label: 'Share',
            //   onTap: () {
            //     // Share functionality
            //   },
            // ),
            _buildDrawerItem(
              context,
              icon: Icons.video_library,
              label: 'Official Launch Video',
              onTap: () {
               Get.to(()=>MyWebsite(url: "https://youtu.be/KSm-A--SJr8?si=89_SDtg-hsszjRiq", title: "Official Launch Video"));
              },
            ),
            // _buildDrawerItem(
            //   context,
            //   icon: Icons.star_rate,
            //   label: 'Rate Us',
            //   onTap: () {
            //     // Redirect to rating functionality
            //   },
            // ),
            _buildDrawerItem(
              context,
              icon: Icons.mail,
              label: 'Mail Us',
              onTap: ()async  {
                // Open mail client
                openGmailApp();


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
