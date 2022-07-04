import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato_record/router/locations.dart';
import 'package:tomato_record/screens/home/items_page.dart';
import 'package:tomato_record/states/user_notifier.dart';
import 'package:beamer/beamer.dart';
import '../widgets/expandable_fab.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ExpandableFab(
        distance: 90,
        children: [
          MaterialButton(
            onPressed: () {
              context.beamToNamed('/$LOCATION_INPUT');
            },
            shape: CircleBorder(),
            height: 30,
            color: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),
          ),
          MaterialButton(
            onPressed: () {},
            shape: CircleBorder(),
            height: 30,
            color: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),
          ),
          MaterialButton(
            onPressed: () {},
            shape: CircleBorder(),
            height: 30,
            color: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ItemsPage(),
          Container(
            color: Colors.accents[3],
          ),
          Container(
            color: Colors.accents[6],
          ),
          Container(
            color: Colors.accents[9],
          ),
        ],
      ),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          '배곧동',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(CupertinoIcons.escape),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.text_justify),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 0
                ? CupertinoIcons.house_fill
                : CupertinoIcons.house),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1
                ? CupertinoIcons.placemark_fill
                : CupertinoIcons.placemark),
            label: '내근처',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 2
                ? CupertinoIcons.chat_bubble_fill
                : CupertinoIcons.chat_bubble),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 3
                ? CupertinoIcons.info_circle_fill
                : CupertinoIcons.info_circle),
            label: '내정보',
          ),
        ],
      ),
    );
  }
}
