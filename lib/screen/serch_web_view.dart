


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchWebViewPage extends StatefulWidget {

  @override
  _SearchWebViewPageState createState() => _SearchWebViewPageState();
}

class _SearchWebViewPageState extends State<SearchWebViewPage> {
  late WebViewController _webViewController;
  bool _canGoBack = false;
  bool _canGoForward = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 30,
          ),
          Expanded(
            child: WebView(
              initialUrl: "https://www.google.com/",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onPageStarted: (value) {},
              onPageFinished: (value) async {
                _canGoBack = (await _webViewController.canGoBack());
                _canGoForward = (await _webViewController.canGoForward());
                setState(() {});
              },
              onWebResourceError: (error) {
                print("onWebResourceError : $error");
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 15,
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () async {
                      String? url;
                      url = await _webViewController.currentUrl();
                      Share.share(url!);
                      setState(() {});
                    },
                  ),
                  Container(
                    width: 15,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _canGoBack ? _webViewController.goBack : null,
                  ),
                  Container(
                    width: 15,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed:
                    _canGoForward ? _webViewController.goForward : null,
                  ),
                  Container(
                    width: 15,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}