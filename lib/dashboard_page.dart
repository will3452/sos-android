import 'package:flutter/material.dart';
import 'package:sos/dashboard_categories_page.dart';
import 'package:sos/dashboard_home_page.dart';
import 'package:sos/dashboard_profile_page.dart';
import 'package:sos/login_page.dart';
import 'package:sos/sos_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 1;
  List<Widget> _dashboardPage = [
    const DashboardCategoriesPage(),
    const DashboardHomePage(),
    const DashboardProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: const Text("SOS APP"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginPage()));
          }, icon: const Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SosPage()));
        },
        child: const Icon(Icons.sos),
      ),
      body: _dashboardPage[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety),
            label: "FIRST-AID",
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "HOME",
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "PROFILE",
          )
        ],
      ),
    );
  }
}
