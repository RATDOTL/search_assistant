import 'package:flutter/material.dart';
import 'package:search_assistant/service/wikipedia_api.dart';
import 'package:search_assistant/service/wikipedia_article.dart';

/// Wikipedia記事プロバイダ
class WikipediaProvider extends ChangeNotifier {
  // 記事リスト
  List<WikipediaArticle> items = [];
  List<WikipediaArticle> additems = [];

  // 記事リストを初期化する
  Future<void> init(context) async {
    Locale locale = Localizations.localeOf(context);
    if (locale == const Locale("ja", "JP")) {
      additems = await jaWikipediaApi().request();
    } else {
      additems = await enWikipediaApi().request();
    }
    items.addAll(additems);
    // リスナーに通知する
    notifyListeners();
  }
}
