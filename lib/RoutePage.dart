import 'package:flutter/material.dart';
import 'package:my_application/Home.dart';
import 'package:my_application/HostSignInPage.dart';
import 'SmartPage.dart';
import 'Home.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget>? _widgetOptions;

  void initState(){
    _widgetOptions = [
      Home(),
      SmartPage(),
      SignInPage(),
    ];
  }

  void _onItemTapped(int index){
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions!.elementAt(selectedIndex)
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home),
          label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.query_stats),
            label: 'Smart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.login),
            label: 'Host',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Color.fromARGB(255, 81, 208, 24),
        onTap: _onItemTapped,
      ),
    );
  }
}

