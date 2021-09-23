import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_assistant/screen/home.dart';
import 'package:search_assistant/service/providers/wikipedia_provider.dart';

void main() => runApp(
    MultiProvider(
      // プロバイダ
      providers: [
        ChangeNotifierProvider(create: (_) => WikipediaProvider()),
      ],
      // アプリケーション
      child: const App(),
    )
);

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(), // ライト用テーマ
      darkTheme: ThemeData.dark(), // ダーク用テーマ
      themeMode: ThemeMode.system, // モードをシステム設定にする
      home: Home(),
    );
  }
}
