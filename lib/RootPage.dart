import 'package:flutter/material.dart';
import 'package:notablonjo/InputPage.dart';
import 'package:notablonjo/UserPage.dart';
import 'providers/NavigationProvider.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {
  final List<Widget> tabNavPage = [InputPage(), UserPage()];
  @override
  Widget build(BuildContext context) {
    final _tabNavProvider = Provider.of<NavigationProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        return showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('Yakin ingin keluar app?'),
              actions: <Widget>[
                FlatButton(
                  child: Text("Ya"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                FlatButton(
                  child: Text("Tidak"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            );
          },
        );
      },
      child: Scaffold(
        body: tabNavPage[_tabNavProvider.currentBottomNavIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey.shade300,
          elevation: 20,
          type: BottomNavigationBarType.fixed,
          currentIndex: _tabNavProvider.currentBottomNavIndex,
          onTap: (index) {
            _tabNavProvider.setCurrentBottomNavIndex = index;
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.grey),
                activeIcon: Icon(Icons.home, color: Colors.blue),
                title: Text('Utama')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.grey),
                activeIcon: Icon(Icons.person, color: Colors.blue),
                title: Text('Info')),
          ],
        ),
      ),
    );
  }
}
