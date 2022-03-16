import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:search_assistant/screen/home.dart';
import 'package:search_assistant/screen/web_view.dart';
import 'package:search_assistant/service/admob/AsInterstitial.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<HistoryData> _historyList = [];

  Future<void> initializeHistory() async {
    _historyList = await HistoryData.getHistoryData();
    setState(() {});
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: getAdBannerAdUnitId(),
    size: AdSize.largeBanner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  final appname = 'Random Word';
  final version = '1.0.1';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeHistory();
  }

  @override
  Widget build(BuildContext context) {
    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('historyTitle'.tr()),
        actions: [
          TextButton(
            onPressed: () async {
              if (await canLaunch(
                  "https://sites.google.com/view/ratdotltin/%E3%83%9B%E3%83%BC%E3%83%A0?authuser=0")) {
                await launch(
                    "https://sites.google.com/view/ratdotltin/%E3%83%9B%E3%83%BC%E3%83%A0?authuser=0");
              }
            },
            child: const Text("RATDOTL",
                style: TextStyle(fontSize: 20, color: Colors.red)),
          ),
          PopupMenuButton<String>(
            itemBuilder: (context) =>
            [
              PopupMenuItem(
                  value: 'dpButton'.tr(),
                  child: Text('dpButton'.tr()),
                  onTap: () async {
                    if (await canLaunch(
                        "https://sites.google.com/view/ratdotltin/%E3%83%9B%E3%83%BC%E3%83%A0?authuser=0")) {
                      await launch(
                          "https://sites.google.com/view/ratdotltin/%E3%83%9B%E3%83%BC%E3%83%A0?authuser=0");
                    }
                  }),
              PopupMenuItem(
                  value: 'tosButton'.tr(),
                  child: Text('tosButton'.tr()),
                  onTap: () async {
                    if (await canLaunch(
                        "https://sites.google.com/view/ratdotltin/random-word/ranword_%E5%88%A9%E7%94%A8%E8%A6%8F%E7%B4%84?authuser=0")) {
                      await launch(
                          "https://sites.google.com/view/ratdotltin/random-word/ranword_%E5%88%A9%E7%94%A8%E8%A6%8F%E7%B4%84?authuser=0");
                    }
                  }),
              PopupMenuItem(
                  value: 'ppButton'.tr(),
                  child: Text('ppButton'.tr()),
                  onTap: () async {
                    if (await canLaunch(
                        "https://sites.google.com/view/ratdotltin/random-word/ranword_%E3%83%97%E3%83%A9%E3%82%A4%E3%83%90%E3%82%B7%E3%83%BC%E3%83%9D%E3%83%AA%E3%82%B7%E3%83%BC?authuser=0")) {
                      await launch(
                          "https://sites.google.com/view/ratdotltin/random-word/ranword_%E3%83%97%E3%83%A9%E3%82%A4%E3%83%90%E3%82%B7%E3%83%BC%E3%83%9D%E3%83%AA%E3%82%B7%E3%83%BC?authuser=0");
                    }
                  }),
              PopupMenuItem(
                value: 'creditButton'.tr(),
                child: InkWell(
                  child: Text('creditButton'.tr()),
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: appname,
                      applicationVersion: version,
                    );
                  },
                ),)
            ],
          )
        ],
      ),
      body: Column(
        children: [
          adContainer,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _historyList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(_historyList[index].title),
                          onTap: () async {
                            String searchWord = "https://www.google.com/search?q=" +
                                _historyList[index].title;
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>
                                    WebViewPage(searchWord)));
                          },
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                              IconButton(
                              icon: const Icon(Icons.share),
                          onPressed: () {
                            Share.share(_historyList[index].title);
                            setState(() {});
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            HistoryData.deleteHistoryData(
                                _historyList[index].id);
                            _historyList.removeAt(index);
                            setState(() {});
                          },
                        ),
                        ],
                      ),)
                      ,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
