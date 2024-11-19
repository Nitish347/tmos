import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfx/pdfx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tmos/colors.dart';

class PDFReaderScreen extends StatefulWidget {
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
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/sample.pdf");

      if (!await file.exists()) {
        final byteData = await DefaultAssetBundle.of(context).load('assets/sample.pdf');
        await file.writeAsBytes(byteData.buffer.asUint8List());
      }

      // Initialize PdfController
      pdfController = PdfController(document: PdfDocument.openFile(file.path));

      setState(() {
        isLoading = false;
      });
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
                  itemCount: 10,
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
                        pdfController.jumpToPage((index + 1) * 5);
                        Navigator.pop(context);
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
      appBar: AppBar(
        title: Text(
          'Interactive PDF Reader',
          style: GoogleFonts.poppins(
            color: AppColors.blueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 4, // Subtle shadow for the AppBar
        shadowColor: Colors.blue.shade100,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon:  Icon(Icons.menu_book, color: AppColors.blueColor ),
              onPressed: (){
                selectChapter(context, pdfController);
              }, // Functionality to select chapters
              tooltip: 'Select Chapter',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.nightlight_round),
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
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Page Info and Progress Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<int>(
              valueListenable: pdfController.pageListenable,
              builder: (context, currentPage, child) {
                final totalPages = pdfController.pagesCount ?? 1;

                return Column(
                  children: [
                    // Page Number Indicator
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
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.blueColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 20.h,)
        ],
      ),
    );
  }
}
