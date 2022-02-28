import 'package:apna_news/helper/data.dart';
import 'package:apna_news/helper/news.dart';
import 'package:apna_news/models/article_model.dart';
import 'package:apna_news/models/categori_model.dart';
import 'package:apna_news/views/article_view.dart';
import 'package:apna_news/views/category_news.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<CategoryModel> categories = <CategoryModel>[];
  List<ArticleModel> articles = <ArticleModel>[];
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(
            'Apna',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            'News',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ]),
        actions: <Widget>[
          Opacity(
            opacity: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.save)),
          )
        ],
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,

          children: <Widget>[
            const DrawerHeader(
              child: Text('Menu drawer'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                size: 40,
              ),
              title: Text('First item'),
              subtitle: Text("This is the 1st item"),
              trailing: Icon(Icons.more_vert),
              onTap: () {},
            ),
            ListTile(
              title: Text('Second item'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: _loading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )

          ///Categories
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 70,
                      child: ListView.builder(
                          itemCount: categories.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return CategotyTile(
                              imageUrl: categories[index].imageUrl,
                              categoryName: categories[index].categoryName,
                            );
                          }),
                    ),

                    ///Blogs
                    Container(
                      padding: EdgeInsets.only(top: 16),
                      child: ListView.builder(
                          itemCount: articles.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          // scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return BlogTile(
                              imageUrl: articles[index].urlToImage,
                              title: articles[index].title,
                              desc: articles[index].description,
                              url: articles[index].url,
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CategotyTile extends StatelessWidget {
  //const CategotyTile({Key? key}) : super(key: key);
  final String imageUrl, categoryName;
  CategotyTile({required this.imageUrl, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryNews(
                category: categoryName.toLowerCase(),
              ),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(
                categoryName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  //const BlogTile({Key? key}) : super(key: key);
  final imageUrl, title, desc, url;
  BlogTile(
      {@required this.imageUrl,
      @required this.title,
      @required this.desc,
      @required this.url});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => ArticleView(blogUrl: url))));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(imageUrl)),
          Text(title,
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 8,
          ),
          Text(desc, style: TextStyle(color: Colors.black54))
        ]),
      ),
    );
  }
}
