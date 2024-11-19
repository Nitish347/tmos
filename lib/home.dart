import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:page_flip/page_flip.dart';
import 'package:path_provider/path_provider.dart';

class PDFReaderScreen extends StatefulWidget {
  @override
  _PDFReaderScreenState createState() => _PDFReaderScreenState();
}

class _PDFReaderScreenState extends State<PDFReaderScreen> {
  String pdfPath = '';
  PdfDocument? pdfDocument;
  List<Image> pdfPages = []; // To store images of PDF pages
  bool isLoading = true; // Track loading state

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

      pdfPath = file.path;
      pdfDocument = await PdfDocument.openFile(pdfPath);

      final totalPages = pdfDocument!.pagesCount;

      for (int i = 1; i <= totalPages; i++) {
        final page = await pdfDocument!.getPage(i);
        final pageImage = await page.render(
          width: page.width * 2, // Adjust for better resolution
          height: page.height * 2,
          format: PdfPageImageFormat.png,
        );
        pdfPages.add(Image.memory(pageImage!.bytes));
        await page.close();
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Reader with Flip Effect'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : PageFlipWidget(
        children: pdfPages
            .map((page) => Container(
          color: Colors.white,
          child: page,
        ))
            .toList(),
      ),
    );
  }
}
