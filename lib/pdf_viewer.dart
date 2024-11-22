import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfx/pdfx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tmos/colors.dart';
import 'package:tmos/controller.dart';
import 'package:tmos/utils.dart';

class PDFReaderScreen extends StatefulWidget {
  String pdfPath;
  bool showChapters;
  String title;
  PDFReaderScreen({required this.pdfPath, required this.title, required this.showChapters});
  @override
  _PDFReaderScreenState createState() => _PDFReaderScreenState();
}

class _PDFReaderScreenState extends State<PDFReaderScreen> {
  late PdfController pdfController; // Controller for the PDF view
  bool isLoading = true; // Track loading state
  bool isNightMode = false; // Night mode toggle
  double currentZoom = 1.0; // Track zoom level

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  Future<void> loadPDF() async {
    try {
      // Copy the PDF file to the app's documents directory
      String savePath = widget.pdfPath.split("assets/")[1];
      log("save Path$savePath");
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/$savePath");

      if (!await file.exists()) {
        log("loading pdf");
        final byteData = await DefaultAssetBundle.of(context).load(widget.pdfPath);
        await file.writeAsBytes(byteData.buffer.asUint8List());
      }

      // Initialize PdfController
      pdfController = PdfController(document: PdfDocument.openFile(file.path));

      setState(() {
        isLoading = false;
      });
      await Future.delayed(Duration(milliseconds: 200));
      setState(() {});
    } catch (e) {
      print('Error loading PDF: $e');
    }
  }

  @override
  void dispose() {
    pdfController.dispose();
    super.dispose();
  }

  void toggleNightMode() {
    setState(() {
      isNightMode = !isNightMode;
    });
  }

  void zoomIn() {
    setState(() {
      currentZoom = (currentZoom + 0.1).clamp(1.0, 3.0);
    });
  }

  void zoomOut() {
    setState(() {
      currentZoom = (currentZoom - 0.1).clamp(1.0, 3.0);
    });
  }

  void selectChapter(BuildContext context, PdfController pdfController) {
    final controller = Get.put(Controller());
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Chapter',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Divider(
                color: Colors.grey.shade300,
                thickness: 1.5,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.bookPart.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [AppColors.blueColor, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.book,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        'Chapter ${index + 1}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey.shade400,
                        size: 18,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PDFReaderScreen(
                                      pdfPath: (controller.bookPart[index]['path'] ?? ""),
                                      title: "Chapter: ${index + 1}",
                                      showChapters: true,
                                    )));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
              color: isNightMode ? Colors.white : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp),
        ),
        centerTitle: true,
        backgroundColor: isNightMode ? Colors.grey : AppColors.blueColor,
        elevation: 4, // Subtle shadow for the AppBar
        shadowColor: Colors.blue.shade100,
        actions: [
          widget.showChapters
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu_book,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      selectChapter(context, pdfController);
                    },
                    tooltip: 'Select Chapter',
                  ),
                )
              : const SizedBox(),
          IconButton(
            icon: Icon(isNightMode ? Icons.sunny : Icons.nightlight_round),
            onPressed: toggleNightMode,
            tooltip: 'Toggle Night Mode',
            color: isNightMode ? Colors.yellow : Colors.white,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // PDF Viewer with Night Mode and Zoom
                Expanded(
                  child: Stack(
                    children: [
                      PdfView(
                        controller: pdfController,
                      ),
                      if (isNightMode)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              color: Colors.yellowAccent.withOpacity(0.3),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Page Info and Progress Bar
                Container(
                  color: isNightMode ? Colors.grey : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ValueListenableBuilder<int>(
                      valueListenable: pdfController.pageListenable,
                      builder: (context, currentPage, child) {
                        final totalPages = pdfController.pagesCount ?? 1;
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: TextButton(
                                      onPressed: () {
                                        pdfController.previousPage(
                                            duration: const Duration(milliseconds: 500),
                                            curve: Curves.linear);
                                      },
                                      child: const Text(
                                        "< Prev",
                                        style: TextStyle(color: AppColors.blueColor),
                                      )),
                                ),
                                Text(
                                  "THE MELANGE OF SUCCESS",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isNightMode ? Colors.white : Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: TextButton(
                                      onPressed: () {
                                        pdfController.nextPage(
                                            duration: const Duration(milliseconds: 500),
                                            curve: Curves.linear);
                                      },
                                      child: const Text(
                                        "Next >",
                                        style: TextStyle(color: AppColors.blueColor),
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$currentPage / $totalPages',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isNightMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Horizontal Progress Indicator
                            LinearProgressIndicator(
                              value: currentPage / totalPages,
                              borderRadius: BorderRadius.circular(50),
                              minHeight: 8,
                              backgroundColor: isNightMode ? AppColors.blueColor : Colors.grey,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                !isNightMode ? AppColors.blueColor : Colors.white,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                // SizedBox(height: 20.h,)
              ],
            ),
    );
  }
}
