import 'package:flutter/material.dart';
import 'package:sos/box_utils.dart';

class DashboardProfilePage extends StatefulWidget {
  const DashboardProfilePage({Key? key}) : super(key: key);

  @override
  State<DashboardProfilePage> createState() => _DashboardProfilePageState();
}

class _DashboardProfilePageState extends State<DashboardProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                child: Text("${box.read('userName')![0]}", style: TextStyle(fontSize: 24),),
                radius: 32,
              )
            ],
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("Name"),
            trailing: Text("${box.read('userName')}"),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text("Email"),
            trailing: Text("${box.read('userEmail')}"),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Date Joined"),
            trailing: Text("${box.read('userJoinedDate')}"),
          ),

        ],
      ),
    );
  }
}
