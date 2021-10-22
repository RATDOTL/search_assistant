import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:search_assistant/screen/history.dart';
import 'package:search_assistant/service/providers/wikipedia_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _selectedValue = 'historyButton'.tr();
  final BannerAd myBanner = BannerAd(
    adUnitId: getTestAdBannerUnitId(),
    size: AdSize.largeBanner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );
  final appname = 'Random Word';
  final version = '1.0.0';

  @override
  Widget build(BuildContext context) {
    context.read<WikipediaProvider>().init(context);
    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );
    return Consumer<WikipediaProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text('homeTitle'.tr()),
            actions: [
              TextButton(
                child: Text('historyButton'.tr(),
                    style: const TextStyle(
                        fontSize: 20, color: Colors.lightGreen)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const History()));
                },
              ),
              PopupMenuButton<String>(
                initialValue: _selectedValue,
                itemBuilder: (context) => [
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
                          );},
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
                        itemCount: provider.items.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(provider.items[index].title),
                              onTap: () async {
                                if (await canLaunch(
                                    "https://www.google.com/search?q=" +
                                        provider.items[index].title)) {
                                  await launch(
                                      "https://www.google.com/search?q=" +
                                          provider.items[index].title);
                                }

                                var history = HistoryData(
                                  id: provider.items[index].id,
                                  title: provider.items[index].title,
                                );
                                await HistoryData.insertHistoryData(history);
                              },
                            ),
                          );
                        },
                      ),
                      Container(
                        height: 40,
                        width: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                            onPressed: () {
                              provider.init(context);
                            },
                            child: Text('SeeMore'.tr())),
                      ),
                      Container(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HistoryData {
  final int id;
  final String title;

  HistoryData({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  @override
  String toString() {
    return 'HistoryData{id: $id, title: $title}';
  }

  static Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'HistoryData_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE HistoryData(id INTEGER PRIMARY KEY AUTOINCREMENT, title Title)",
        );
      },
      version: 1,
    );
    return _database;
  }

  static Future<void> insertHistoryData(HistoryData historyData) async {
    final Database db = await database;
    await db.insert(
      'historyData',
      historyData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<HistoryData>> getHistoryData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('historyData');
    return List.generate(maps.length, (i) {
      return HistoryData(
        id: maps[i]['id'],
        title: maps[i]['title'],
      );
    });
  }

  static Future<void> updateHistoryData(HistoryData historyData) async {
    final db = await database;
    await db.update(
      'historyData',
      historyData.toMap(),
      where: "id = ?",
      whereArgs: [historyData.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  static Future<void> deleteHistoryData(int id) async {
    final db = await database;
    await db.delete(
      'historyData',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
