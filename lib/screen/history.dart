import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:search_assistant/screen/home.dart';
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
    adUnitId: getTestAdBannerUnitId(),
    size: AdSize.largeBanner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

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
                            if (await canLaunch(
                                "https://www.google.com/search?q=" +
                                    _historyList[index].title)) {
                              await launch("https://www.google.com/search?q=" +
                                  _historyList[index].title);
                            }
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              HistoryData.deleteHistoryData(
                                  _historyList[index].id);
                              _historyList.removeAt(index);
                              setState(() {});
                            },
                          ),
                        ),
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
