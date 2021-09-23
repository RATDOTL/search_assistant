import 'package:flutter/material.dart';
import 'package:search_assistant/service/wikipedia_api.dart';
import 'package:search_assistant/service/wikipedia_article.dart';


/// Wikipedia記事プロバイダ
class WikipediaProvider extends ChangeNotifier {

  // 記事リスト
  List<WikipediaArticle> items = [];

  // 記事リストを初期化する
  Future<void> init() async {
    // 記事リストをAPIから取得する
    items = await WikipediaApi().request();
    // リスナーに通知する
    notifyListeners();
  }
}