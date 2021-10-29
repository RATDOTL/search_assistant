import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:search_assistant/screen/home.dart';
import 'package:search_assistant/service/providers/wikipedia_provider.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  // Needs to be called so that we can await for EasyLocalization.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(EasyLocalization(
    // List of supported locales.
    supportedLocales: const [Locale('en', ''), Locale('ja', 'JP')],
    // Path to your folder with localization files.
    path: 'assets/translations',
    // <-- change the path of the translation files
    // 	Returns the locale when the locale is not in the list supportedLocales.(Not required)
    fallbackLocale: const Locale('en', ''),
    // Place for your main page widget.

    // アプリケーション
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: MultiProvider(
          // プロバイダ
          providers: [
            ChangeNotifierProvider(create: (context) => WikipediaProvider()),
          ],
          child: const Home(),
        ));
  }
}

String getAdBannerAdUnitId() {
  String bannerUnitId = "";
  if (Platform.isAndroid) {
    // Android のとき
    bannerUnitId = "ca-app-pub-8481794717512198/2239456502";

  } else if (Platform.isIOS) {
    // iOSのとき
    bannerUnitId = '';
  }
  return bannerUnitId;

}