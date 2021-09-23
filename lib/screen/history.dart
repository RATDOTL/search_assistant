import 'package:flutter/material.dart';
import 'package:search_assistant/screen/home.dart';
import 'package:url_launcher/url_launcher.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('検索履歴'),
      ),
      body: ListView.builder(
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
                title: Text(historyList[index]),
                onTap: () async {
                  if (await canLaunch("https://www.google.com/search?q=" +
                      historyList[index])) {
                    await launch("https://www.google.com/search?q=" +
                        historyList[index]);
                  }
                }),
          );
        },
      ),
    );
  }
}
