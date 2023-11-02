import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos/injury_page.dart';
import 'package:video_player/video_player.dart';

class CategoryPage extends StatefulWidget {
  final dynamic category;
  const CategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("video ${widget.category}");
    _controller = VideoPlayerController.networkUrl(Uri.parse("https://sos-app.elezerk.net/storage/${widget.category['video']}"))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category['name']}"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'), // Use the path defined in pubspec.yaml
            fit: BoxFit.cover, // You can adjust the fit as needed
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : Text('video loading... getting from server'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  ElevatedButton(onPressed: () {
                    _controller.play();
                  }, child: Icon(Icons.play_arrow)),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(onPressed: () {
                    _controller.pause();
                  }, child: Icon(Icons.pause)),
                ],
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(itemBuilder: (_, i) => ListTile(title: Text("${widget.category['injuries'][i]['name']}"), trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                          InjuryPage(injury: widget.category['injuries'][i],)
                      )
                      );
                    },
                    icon: Icon(Icons.chevron_right),
                  ),
                  ), itemCount: widget.category['injuries'].length, )),
            ],
          )
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
