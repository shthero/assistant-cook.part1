import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appbar',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appbar icon menu'),
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            print('menu button is clicked');
          },
          icon: const Icon(Icons.menu),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              print('Shopping cart button is clicked');
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          IconButton(
            onPressed: () {
              print('Search button is clicked');
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/aha.jpg'),
                backgroundColor: Colors.white,
              ),
              otherAccountsPictures: const <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage('assets/gotya.jpg'),
                  backgroundColor: Colors.white,
                ),
                // 
              ],
              accountName: const Text('rascal'),
              accountEmail: const Text('dhkzldi12@naver.com'),
              onDetailsPressed: (){
                  print('arrow is clicked');
                },
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0)
                  )
                ),
            ),
            ListTile(
              leading: Icon(Icons.home,
              color: Colors.grey[850],
              ),
              title: const Text('Home'),
              onTap: (){
                print('Home is clicked');
              },
              trailing: const Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(Icons.settings,
              color: Colors.grey[850],
              ),
              title: const Text('Setting'),
              onTap: (){
                print('Setting is clicked');
              },
              trailing: const Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(Icons.question_answer,
              color: Colors.grey[850],
              ),
              title: const Text('Q&A'),
              onTap: (){
                print('Q&A is clicked');
              },
              trailing: const Icon(Icons.add),
            ),
          ]
        ),
      ),
    );
  }
}
