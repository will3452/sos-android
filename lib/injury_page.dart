import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sos/sos_page.dart';
class InjuryPage extends StatefulWidget {
  final dynamic injury;
  const InjuryPage({Key? key, required this.injury}) : super(key: key);

  @override
  State<InjuryPage> createState() => _InjuryPageState();
}

class _InjuryPageState extends State<InjuryPage> {
  List <Widget> _tabs = [];
  List<Widget> _steps = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      for (int i = 0; i < widget.injury['steps'].length; i++) {
        _tabs.add(Tab(text: "Step ${widget.injury['steps'][i]['step']}",));
        _steps.add(SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                  ListTile(title: Text("Direction"), subtitle: Text("${widget.injury['steps'][i]['description']}"),),
                  Center(child: Image.network("https://sos-app.elezerk.net/storage/${widget.injury['steps'][i]['image']}")),
              ],
            ),
          ),
        ));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.injury['name']}"),
          bottom: TabBar(tabs: _tabs.toList(), isScrollable: true),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.png'), // Use the path defined in pubspec.yaml
              fit: BoxFit.cover, // You can adjust the fit as needed
            ),
          ),
          child: TabBarView(
            children: [
              ..._steps
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SosPage()));
          },
          child: const Icon(Icons.sos),
        ),
      ),
    ); 
  }
}
