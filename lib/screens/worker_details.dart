import 'dart:typed_data';
import 'package:areamen/main.dart';
import 'package:areamen/screens/home_screen.dart';
import 'package:areamen/utils/auth_methods.dart';
import 'package:areamen/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerDetailScreen extends StatefulWidget {
  final String phoneNumber;

  const WorkerDetailScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  State<WorkerDetailScreen> createState() => _WorkerDetailScreenState();
}

class _WorkerDetailScreenState extends State<WorkerDetailScreen> {
  String img =
      'https://imgs.search.brave.com/W8c9qYhrPNdwQjy6g2H3CSfURSFpzuXMxv5O5-eqnf8/rs:fit:1200:976:1/g:ce/aHR0cHM6Ly9pLnN0/YWNrLmltZ3VyLmNv/bS9sNjBIZi5wbmc';
  Uint8List? _adharcard;
  Uint8List? _image;
  String? city;
  String? local;
  bool _visibel = false;
  bool _uploadAdharBool = true;
  bool _AccsesLocationBool = true;

  final List<String> CatList = [
    'Mechanic',
    'Electrician',
    'Plumber',
    'Appliances Repair',
    'Furniture Repair'
  ];

  List<String> SubCatList = <String>['Bike', 'Cycle', 'Car'];
  String valChoose = '';
  String Cat = 'Mechanic';
  String Subcat = 'Bike';

  bool ShowSubCat = true;

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position);
    _GetAddressFromLatLong(position);
  }

  Future<void> _GetAddressFromLatLong(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      city = placemark[0].locality;
      local = placemark[0].subLocality;
      print(placemark);
      _visibel = false;
    });
  }

  void AddSubCat() {
    setState(() {
      if (Cat == 'Mechanic') {
        SubCatList = <String>['Bike', 'Cycle', 'Car'];
        Subcat = 'Bike';
        ShowSubCat = true;
      } else if (Cat == 'Appliances Repair') {
        SubCatList = <String>[
          'Water Purifier',
          'Air Conditioner',
          'Geyser',
          'Washing Machine',
          'Television',
          'Fan',
          'Refrigerator',
          ' Air Cooler Repair'
        ];
        Subcat = 'Water Purifier';
        ShowSubCat = true;
      } else if (Cat == 'Furniture Repair') {
        SubCatList = <String>['Carpenters', 'Pepperfry'];
        Subcat = 'Carpenters';
        ShowSubCat = true;
      } else {
        SubCatList = [];
        Subcat = '';
        ShowSubCat = false;
      }
    });
  }

  void selectAdharcard() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _adharcard = im;
    });
  }

  void selectProfile() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void StoreCredentionToFirebase() async {
    if (_nameController.text.trim().isNotEmpty &&
            _addressController.text.trim().isNotEmpty &&
            Cat.isNotEmpty &&
            city!.trim().isNotEmpty /*&&
        local!.trim().isNotEmpty*/
        ) {
      final SharedPreferences pref = await SharedPreferences.getInstance();

      if (_adharcard == null) {
        showSnakBar('Upload your Adharcard', context);
      } else if (_image == null) {
        showSnakBar('Select an profile picture', context);
      } else if (_adharcard != null && _image != null) {
        await AuthMethods().signUpWorker(
          city: city!,
          local: local ?? "1",
          name: _nameController.text,
          phone: widget.phoneNumber,
          address: _addressController.text,
          mainCat: Cat,
          subCat: Subcat.trim() ?? Cat,
          adharcardPhoto: _adharcard!,
          profilePhoto: _image!,
        );
        pref.setBool('isWorker', true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) => const HomeScreen()),
          ),
        );
      }
    } else {
      print(_nameController.text);
      print(city!);
      print(local!);
      print(Cat);
      print(Subcat);
      print(widget.phoneNumber);
      print(_addressController.text);
      showSnakBar('Enter the details', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Visibility(
                  visible: _visibel,
                  child: const CircularProgressIndicator(),
                ),
              ),
              Padding(
                padding: const  EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('WORKER\'S DETAILS'),
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
                            icon: const Icon(
                              Icons.add_a_photo_rounded,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: 350,
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(),
                        ),
                      ),
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
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
                    const SizedBox(height: 10),
                    //Address
                    Container(
                      width: 350,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide()),
                      ),
                      child: TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.location_pin),
                          hintText: 'Address',
                          hintStyle: TextStyle(fontSize: 12),
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // CatList
                    DropdownButton<String>(
                      isExpanded: true,
                      value: Cat,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          Cat = value!;
                          AddSubCat();
                        });
                      },
                      items: CatList.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    //SubCatList
                    Visibility(
                      visible: ShowSubCat,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: Subcat,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            Subcat = value!;
                          });
                        },
                        items: SubCatList.map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Upload Adharcard
                    MaterialButton(
                      onPressed: () {
                        if (_uploadAdharBool) {
                          selectAdharcard();
                        } else {
                          showSnakBar('Adharcard Alredy Uploaded', context);
                        }
                      },
                      child: const Text('Click to Upload Adharcard'),
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 10),
                    // Location Accses
                    MaterialButton(
                      onPressed: () async {
                        setState(() {
                          _visibel = true;
                        });
                        if (_AccsesLocationBool) {
                          getLocation();
                        } else {
                          showSnakBar('Succsesfully Accessed', context);
                        }
                        print('location working');
                      },
                      child: const Text('Give location Accses'),
                      color: Colors.greenAccent,
                    ),
                    const SizedBox(height: 10),
                    // Continue Button
                    MaterialButton(
                      padding: const EdgeInsets.all(10),
                      minWidth: double.maxFinite,
                      onPressed: () async {
                        setState(() {
                          _visibel = true;
                        });
                        StoreCredentionToFirebase();
                      },
                      child: const Text('Continue'),
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
