import 'dart:typed_data';
import 'package:areamen/screens/home_screen.dart';
import 'package:areamen/utils/auth_methods.dart';
import 'package:areamen/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerScreen extends StatefulWidget {
  final String phoneNumber;

  CustomerScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  String? city;
  String? local;
  Uint8List? _image;
  bool _AccsesLocationBool = true;
  String img =
      'https://imgs.search.brave.com/W8c9qYhrPNdwQjy6g2H3CSfURSFpzuXMxv5O5-eqnf8/rs:fit:1200:976:1/g:ce/aHR0cHM6Ly9pLnN0/YWNrLmltZ3VyLmNv/bS9sNjBIZi5wbmc';
  bool _visibel = false;

  final _nameController = TextEditingController();

  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position);
    GetAddressFromLatLong(position);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      city = placemark[0].locality;
      local = placemark[0].subLocality;
      print(placemark);
      _visibel = false;
    });
  }

  void selectProfile() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void StoreCredentionToFirebase(BuildContext context) async {
    if (_nameController.text.trim().isNotEmpty &&
        city!.trim().isNotEmpty &&
        local!.trim().isNotEmpty) {
      if (_image == null) {
        showSnakBar('Select an profile picture', context);
      } else {
        AuthMethods().signUpCustomer(
          name: _nameController.text.trim(),
          profilePhoto: _image!,
          phone: widget.phoneNumber,
          city: city!,
          local: local!,
        );

        var pref = await SharedPreferences.getInstance();

        pref.setBool('isWorker', false);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const HomeScreen())));
      }
    } else {
      showSnakBar('Enter the details', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('CUSTOMER\'S DETAILS'),
                SizedBox(height: 30),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(img),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 60,
                      child: IconButton(
                        onPressed: () => selectProfile(),
                        icon: Icon(
                          Icons.add_a_photo_rounded,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 350,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(),
                    ),
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_circle),
                      hintText: 'Name',
                      hintStyle: TextStyle(fontSize: 12),
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Location Accses
                MaterialButton(
                  onPressed: () async {
                    if (_AccsesLocationBool) {
                      getLocation();
                    } else {
                      showSnakBar('Succsesfully Accessed', context);
                    }
                  },
                  child: Text('Give your location Accses'),
                  color: Colors.greenAccent,
                ),
                SizedBox(height: 10),
                // Continue Button
                MaterialButton(
                  padding: const EdgeInsets.all(10),
                  minWidth: double.maxFinite,
                  onPressed: () => StoreCredentionToFirebase(context),
                  child: Text('Continue'),
                  color: Colors.blueAccent,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
