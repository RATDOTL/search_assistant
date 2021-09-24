import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:search_assistant/service/wikipedia_article.dart';

/// Wikipediaの記事を取得するAPI
class WikipediaApi {
  static const _domain = 'ja.wikipedia.org';
  static const _path = '/w/api.php';
  static const _params = {
    'format': 'json',
    'action': 'query',
    'list': 'random',
    'rnnamespace': '0',
    'rnlimit': '40',
  };

  // インスタンス
  static final WikipediaApi _instance = WikipediaApi._();

  // コンストラクタ
  WikipediaApi._();

  // ファクトリコンストラクタ
  factory WikipediaApi() => _instance;

  // リクエスト実行
  Future<List<WikipediaArticle>> request() async {
    var url = Uri.https(_domain, _path, _params);
    http.Response response = await http.get(url);
    var parsed = json.decode(response.body);
    var data = parsed['query']['random'] as List;
    return data.map((e) => WikipediaArticle.fromJson(e)).toList();
  }
}