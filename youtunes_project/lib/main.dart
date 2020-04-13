import 'package:flutter/material.dart';
import 'file:///C:/Users/min48/AndroidStudioProjects/YouTunes/youtunes_project/lib/screens/homescreen.dart';
import 'file:///C:/Users/min48/AndroidStudioProjects/YouTunes/youtunes_project/lib/screens/search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTunes Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'YouTunes Music Player Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(),
    /*
    Text(
      'Index 2: Library',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    */
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      */
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          /*
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            title: Text('Library'),
          ),
           */
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
        onTap: _onItemTapped,
      ),
    );
  }
}
