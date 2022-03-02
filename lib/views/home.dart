import 'package:apna_news/helper/data.dart';
import 'package:apna_news/helper/news.dart';
import 'package:apna_news/models/article_model.dart';
import 'package:apna_news/models/categori_model.dart';
import 'package:apna_news/views/article_view.dart';
import 'package:apna_news/views/category_news.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user_model.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var currentUser = FirebaseAuth.instance.currentUser;
  List<CategoryModel> categories = <CategoryModel>[];
  List<ArticleModel> articles = <ArticleModel>[];
  bool _loading = true;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
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
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.notification_important),
            tooltip: 'Comment Icon',
            onPressed: () {},
          ),
        ],
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('User Id :'),
              accountEmail:
                  Text('Email: ${FirebaseAuth.instance.currentUser!.email}'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/logo.png'),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                size: 40,
                color: Colors.black,
              ),
              title: Text(
                'Profile',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'Mprofile');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                size: 40,
                color: Colors.green,
              ),
              title: Text(
                'Home',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.dark_mode,
                size: 40,
                color: Colors.black,
              ),
              title: Container(
                child: Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.notifications,
                size: 40,
                color: Colors.black,
              ),
              title: Text(
                'Notification',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                size: 40,
                color: Colors.red,
              ),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'login');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.ondemand_video,
              color: Colors.black,
            ),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.category,
              color: Colors.black,
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: 'Profile',
          ),
        ],
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
