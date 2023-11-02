import 'package:flutter/material.dart';
import 'package:sos/category_page.dart';

import 'http_utils.dart';

class DashboardCategoriesPage extends StatefulWidget {
  const DashboardCategoriesPage({Key? key}) : super(key: key);

  @override
  State<DashboardCategoriesPage> createState() => _DashboardCategoriesPageState();
}

class _DashboardCategoriesPageState extends State<DashboardCategoriesPage> {

  var _categories = [];
  bool _loading = true;

  void _loadData() async {
    var response = await appDio.get('/categories');
    var data = response.data;
    setState(() {
      _categories = data;
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }
  @override
  Widget build(BuildContext context) {
    return _loading ? Center(
      child: CircularProgressIndicator(),
    ): Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.png'), // Use the path defined in pubspec.yaml
          fit: BoxFit.cover, // You can adjust the fit as needed
        ),
      ),
      child: ListView.builder(itemBuilder: (_, index) {
        return ListTile(
          title: Text(_categories[index]['name']),
          subtitle: Text("${_categories[index]['injuries'].map( (e) => e['name']).toList().join(', ')}"),
          trailing: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                  CategoryPage(category: _categories[index],)
              )
              );
            },
            icon: Icon(Icons.chevron_right),
          ),
        );
      },itemCount: _categories.length,),
    );
  }
}
