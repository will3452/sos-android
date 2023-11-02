import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sos/dashboard_page.dart';

import 'box_utils.dart';
import 'http_utils.dart';

class SosPage extends StatefulWidget {
  const SosPage({Key? key}) : super(key: key);

  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
  var _position = null;
  bool _loading = true;
  TextEditingController _message = TextEditingController(text: "");

  void _loadPosition() async {
    var position = await _determinePosition();
    setState(() {
      _position = position;
      _loading = false;
    });

    print("position ${_position}");
  }

  void _submit() async {
    try {
      setState(() {
        _loading = true;
      });
      await appDio.post('/my-sos', options: Options(
        headers: {
          'Authorization': 'Bearer ${box.read('token')}',
        },
      ), data: {
        'type': 'MOBILE',
        'message': _message.text,
        'lat': _position!.latitude,
        'lng': _position!.longitude,
        'status' : 'PENDING',
      });
      showDialog(context: context, builder: (_) => AlertDialog(
        title: Text("SUBMITTED SUCCESSFULLY"),
        icon: Icon(Icons.check),
        content: Text("Your location and information has been submitted to near rescuer."),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DashboardPage()));
            }, icon: Icon(Icons.home))
        ],
      )
      );
    } catch (error) {
      showDialog(context: context, builder: (_) => AlertDialog(
        title: Text("FAILED"),
        icon: Icon(Icons.heart_broken),
        content: Text("Request failed to submit, try again."),
      )
      );
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
    _loadPosition();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SOS"),
      ),

      body: _loading ? Center(
        child: CircularProgressIndicator(),
      ) : SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: FlutterMap(
                options: MapOptions(
                    zoom: 15,
                    center: LatLng(_position!.latitude, _position!.longitude)
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(point: LatLng(_position!.latitude, _position!.longitude), builder: (_) => Image.asset('assets/sos.png')),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                decoration: InputDecoration(
                  label: Text("Description"),
                ),
                controller: _message,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {
                  _submit();
                  // Navigator.of(context).push(MaterialPageRoute(builder: (_) => DashboardPage()));
                }, child: Text("SUBMIT NOW")),
              ),
            )
          ],
        ),
      ),
    );
  }
}
