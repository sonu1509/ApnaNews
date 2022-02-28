class ArticleModel {
  //late String author;
  late String title;
  late String description;
  late String url;
  late String urlToImage;
  //late String content;
  late String publishedAt;
  ArticleModel(
      { //required this.author,
      required this.title,
      required this.description,
      required this.url,
      required this.urlToImage,
      //required this.content,
      required this.publishedAt});
  /*factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
        author: json['author'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        url: json['url'] as String,
        urlToImage: json['urlToImage'] as String,
        content: json['content'],
        publishedAt: json['publishedAt'] as String);
  }*/
}
