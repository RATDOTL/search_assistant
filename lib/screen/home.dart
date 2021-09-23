import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_assistant/screen/history.dart';
import 'package:search_assistant/service/providers/wikipedia_provider.dart';
import 'package:url_launcher/url_launcher.dart';


final List<String> historyList = [];

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    context.read<WikipediaProvider>().init();

    return Consumer<WikipediaProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("検索候補リスト"),
            actions: [
              TextButton(
                child: const Text(
                  "履歴",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => History()));
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => provider.init(),
            child: ListView.builder(
              itemCount: provider.items.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(provider.items[index].title),
                    onTap: () async {
                      if (await canLaunch("https://www.google.com/search?q=" +
                          provider.items[index].title)) {
                        await launch("https://www.google.com/search?q=" +
                            provider.items[index].title);
                      }
                      setState(() {
                        historyList.add(provider.items[index].title);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
