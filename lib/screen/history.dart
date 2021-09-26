
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:search_assistant/screen/home.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('historyTitle'.tr()),
      ),
      body: SingleChildScrollView(
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
                        if (await canLaunch("https://www.google.com/search?q=" +
                            _historyList[index].title)) {
                          await launch("https://www.google.com/search?q=" +
                              _historyList[index].title);
                        }
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
