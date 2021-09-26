import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:search_assistant/service/wikipedia_article.dart';

/// Wikipediaの記事を取得するAPI
class jaWikipediaApi {
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
  static final jaWikipediaApi _instance = jaWikipediaApi._();

  // コンストラクタ
  jaWikipediaApi._();

  // ファクトリコンストラクタ
  factory jaWikipediaApi() => _instance;

  // リクエスト実行
  Future<List<WikipediaArticle>> request() async {
    var url = Uri.https(_domain, _path, _params);
    http.Response response = await http.get(url);
    var parsed = json.decode(response.body);
    var data = parsed['query']['random'] as List;
    return data.map((e) => WikipediaArticle.fromJson(e)).toList();
  }
}

class enWikipediaApi {
  static const _domain = 'en.wikipedia.org';
  static const _path = '/w/api.php';
  static const _params = {
    'format': 'json',
    'action': 'query',
    'list': 'random',
    'rnnamespace': '0',
    'rnlimit': '40',
  };

  // インスタンス
  static final enWikipediaApi _instance = enWikipediaApi._();

  // コンストラクタ
  enWikipediaApi._();

  // ファクトリコンストラクタ
  factory enWikipediaApi() => _instance;

  // リクエスト実行
  Future<List<WikipediaArticle>> request() async {
    var url = Uri.https(_domain, _path, _params);
    http.Response response = await http.get(url);
    var parsed = json.decode(response.body);
    var data = parsed['query']['random'] as List;
    return data.map((e) => WikipediaArticle.fromJson(e)).toList();
  }
}
