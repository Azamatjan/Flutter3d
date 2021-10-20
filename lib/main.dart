import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cube/flutter_cube.dart';

void main() {
  runApp(const MyApp());
}

List images = [
  {
    "img": "assets/images/squidgame1.jpeg",
  },
  {
    "img": "assets/images/squidgame2.png",
  },
  {
    "img": "assets/images/squidgame3.jpeg",
  }
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late Scene _scene;
  Object? _bunny;
  late AnimationController _controller;

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    scene.camera.zoom = 10;
    scene.light.position.setFrom(Vector3(0, 10, 10));
    _bunny = Object(lighting: true, fileName: 'assets/3d/squidGame.obj');
    scene.world.add(_bunny!);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 30000), vsync: this)
      ..addListener(() {
        if (_bunny != null) {
          _bunny!.rotation.y = _controller.value * 360;
          _bunny!.updateTransform();
          _scene.update();
        }
      })
      ..repeat();
  }

  buildImageList() {
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 16),
      child: Container(
        height: 150.0,
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 15,
            );
          },
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            Map image = images.reversed.toList()[index];

            return Container(
              height: 140,
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  "${image["img"]}",
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF3256a8),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Cube(
                onSceneCreated: _onSceneCreated,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 530,right: 16, left: 16),
            child: Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text('Squid Game', style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Text(
                            "Squid Game is a South Korean survival drama television series streaming on Netflix. Written and directed by Hwang Dong-hyuk. \nRead more...",
                            style: TextStyle(fontSize: 16, color: Colors.black54)),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        indent: 16,
                        endIndent: 16,
                        thickness: 5,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      buildImageList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
