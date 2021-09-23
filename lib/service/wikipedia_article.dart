

class WikipediaArticle {
  // ID
  final int id;
  // タイトル
  String title;

  WikipediaArticle({required this.id, required this.title});

  WikipediaArticle.fromJson(Map<String, dynamic> json) :
        id = json['id'] as int,
        title = json['title'].toString();
}