import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'colors.dart';

class MyWebsite extends StatefulWidget {
  final String url;
  final String title;

  MyWebsite({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  State<MyWebsite> createState() => _MyWebsiteState();
}

class _MyWebsiteState extends State<MyWebsite> {
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        var canGoBack = await inAppWebViewController.canGoBack();

        if (canGoBack) {
          inAppWebViewController.goBack();
          return false;
        } else {
          // Show a dialog or a snackbar to confirm exit
          return true; // Allow the app to pop the route
        }
      },
      child: SafeArea(
        child: Scaffold(

          appBar: AppBar(
            automaticallyImplyLeading: true,

            centerTitle: true,
            iconTheme: IconThemeData(
                color: Colors.white
            ),
            backgroundColor: AppColors.blueColor,
            titleTextStyle: TextStyle(color: Colors.white,fontSize: screenHeight*0.023),

           title:  Text(
             widget.title,
           ),
            surfaceTintColor: const Color(0xff0D3284FF),
          ),
          body: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                onWebViewCreated: (InAppWebViewController controller) {
                  inAppWebViewController = controller;
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    _progress = progress / 100;
                  });
                },
                initialSettings: InAppWebViewSettings(
                  pageZoom: 10,
                  supportZoom: false, // Disable zoom
                  disableContextMenu:
                      false, // Optional: disable the context menu
                ),
              ),
              _progress < 1
                  ? Container(
                      child: LinearProgressIndicator(
                        value: _progress,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
