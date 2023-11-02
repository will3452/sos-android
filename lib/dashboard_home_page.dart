import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sos/box_utils.dart';
import 'package:sos/http_utils.dart';

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({Key? key}) : super(key: key);

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  var _categories = [];
  var _users = [];
  var _sos = [];
  var _mySos = [];
  var _notifications = [];
  bool _loading = true;
  
  void _loadData() async {
    try {
      var response = await appDio.get('/categories');
      var data = response.data;
      setState(() {
        _categories = data;
      });

      response = await appDio.get('/sos');
      data = response.data;
      setState(() {
        _sos = data;
      });

      response = await appDio.get('/my-sos', options: Options(
        headers: {
          "Authorization": "Bearer ${box.read('token')}",
        }
      ));

      data = response.data;
      setState(() {
        _mySos = data;
      });

      print("$data");
    } catch (error) {
      showDialog(context: context, builder: (_) => AlertDialog( title: Text("Error"),content: Text("Resources failed to load."),));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return _loading ? const Center(
      child: CircularProgressIndicator(),
    ) : SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           // SizedBox(
           //   width: MediaQuery.of(context).size.width,
           //   height: 300,
           //   child: FlutterMap(
           //     options: MapOptions(
           //         zoom: 9.2,
           //         center: LatLng(15.484675999999999, 120.6309075)
           //     ),
           //     children: [
           //       TileLayer(
           //         urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
           //         userAgentPackageName: 'com.example.app',
           //       )
           //     ],
           //   ),
           // ),
            Row(
              children: [
                Expanded(child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("${_categories.length ?? 0}", style: TextStyle(
                          fontSize: 32,
                        ),),
                        Icon(Icons.collections, size: 45),
                        Text("Categories"),
                      ],
                    ),
                  ),
                ),
                ),
                Expanded(child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("${_sos.length ?? 0}", style: TextStyle(
                          fontSize: 32,
                        ),),
                        Icon(Icons.sos, size: 45),
                        Text("Requests"),
                      ],
                    ),
                  ),
                ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("20", style: TextStyle(
                          fontSize: 32,
                        ),),
                        Icon(Icons.supervised_user_circle, size: 45),
                        Text("Active users"),
                      ],
                    ),
                  ),
                ),
                ),
                // Expanded(child: Card(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Column(
                //       children: [
                //         Text("3", style: TextStyle(
                //           fontSize: 32,
                //         ),),
                //         Icon(Icons.notifications, size: 45),
                //         Text("Notifications"),
                //       ],
                //     ),
                //   ),
                // ),
                // )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(Icons.list),
                Text("  Request Logs", style: TextStyle(
                  fontSize: 18,
                ),),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: ListView(
                children: _mySos.map((e) => ListTile(
                  dense: true,
                  title: Text(e['message']),
                  leading: Icon(Icons.info_rounded),
                  subtitle: Text("${e['lat']}, ${e['lng']}"),
                  trailing: Text("${DateTime.parse(e['created_at']).month}/${DateTime.parse(e['created_at']).day}/${DateTime.parse(e['created_at']).year}"),
                )).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
