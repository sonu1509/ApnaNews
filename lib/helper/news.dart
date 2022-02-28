import 'dart:convert';
import 'package:apna_news/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class News {
  List<ArticleModel> news = [];
  Future<void> getNews() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=37365d449edf4edb87437f5675f4931f";
    //var response = await http.get(Uri.http(url, ''));

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
              title: element['title'],
              // author: element['author'],
              description: element['description'],
              url: element['url'],
              urlToImage: element['urlToImage'],
              //content: element['content'],
              publishedAt: element['publishedAt']);
          news.add(articleModel);
        }
      });
    }
  }
}

class CategoryNewsClass {
  List<ArticleModel> news = [];
  Future<void> getNews(String category) async {
    String url =
        "https://newsapi.org/v2/top-headlines?category=$category&country=in&apiKey=37365d449edf4edb87437f5675f4931f";
    //var response = await http.get(Uri.http(url, ''));

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
              title: element['title'],
              // author: element['author'],
              description: element['description'],
              url: element['url'],
              urlToImage: element['urlToImage'],
              //content: element['content'],
              publishedAt: element['publishedAt']);
          news.add(articleModel);
        }
      });
    }
  }
}
