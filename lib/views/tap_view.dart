import 'package:flutter/material.dart';
import 'package:pain_record/views/rss_list_view.dart';
import 'package:pain_record/views/setting_view.dart';

class TapView extends StatefulWidget {
  const TapView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TapView();
}

class _TapView extends State<TapView> {
  final pages = [const RssListView(), const SettingView()];
  final titles = ['목록 보기', '설정'];

  int _selectIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectIndex]),
      ),
      body: pages[_selectIndex],
      // body: Container(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        selectedFontSize: 20,
        selectedIconTheme:
            const IconThemeData(color: Colors.amberAccent, size: 40),
        selectedItemColor: Colors.amberAccent,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        iconSize: 40,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '목록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
        currentIndex: _selectIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
