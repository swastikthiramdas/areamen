import 'package:areamen/provider/user_provider.dart';
import 'package:areamen/screens/all_workers_screen.dart';
import 'package:areamen/screens/subscat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final catImages = [
      'images/mechanic.png',
      'images/electrician.png',
      'images/plumber.png',
      'images/ap_repair.png',
      'images/furniture_repair.png'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HandyHub',
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
                      local: local ?? "1",
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllWorkerScreen(
                      cat: cats[index],
                      local: local ?? "1",
                    ),
                  ),
                );
              }
            },
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(catImages[index]),
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.fitWidth
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    cats[index],
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
