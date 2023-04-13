import 'package:areamen/screens/all_workers_screen.dart';
import 'package:areamen/screens/subscat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? local;

  @override
  void initState() {
    super.initState();
    getLocation();
  }


  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position);
    GetCurruntLocation(position);
  }

  Future<void> GetCurruntLocation(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    local = placemark[0].subLocality;
    print(placemark);
  }

  @override
  Widget build(BuildContext context) {
    final cats = [
      'Mechanic',
      'Electrician',
      'Plumber',
      'Appliances Repair',
      'Furniture Repair'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AreaMen',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: GridView.builder(
        itemCount: cats.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (cats[index] != 'Electrician' && cats[index] != 'Plumber') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubCatScreen(
                      cats: cats[index],
                      local: local,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllWorkerScreen(
                      cat: "Electrician",
                      local: local,
                    ),
                  ),
                );
              }
            },
            child: Container(
              height: 100,
              width: 100,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  cats[index],
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
