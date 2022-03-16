import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  String searchWord;
  WebViewPage(this.searchWord);

  @override
  _WebViewPageState createState() => _WebViewPageState(searchWord);
}

class _WebViewPageState extends State<WebViewPage> {
  String searchWord;
  _WebViewPageState(this.searchWord);
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
              initialUrl: searchWord,
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
                      Share.share(searchWord.replaceAll("https://www.google.com/search?q=","") + '\n' + url!);
                      setState(() {});
                    },
                  ),
                  Container(
                    width: 15,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back,color: Colors.white),
                    onPressed: _canGoBack ? _webViewController.goBack : null,
                  ),
                  Container(
                    width: 15,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward,color: Colors.white),
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
