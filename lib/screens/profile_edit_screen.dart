import 'dart:typed_data';
import 'package:areamen/provider/user_provider.dart';
import 'package:areamen/utils/storage_methods.dart';
import 'package:areamen/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../utils/firestore_methods.dart';

class ProfileEditScreen extends StatefulWidget {
  final String name;
  final String address;
  final String cat;
  final String subCat;
  final String url;
  final String id;

  ProfileEditScreen({
    Key? key,
    required this.url,
    required this.id,
    required this.name,
    required this.address,
    required this.cat, required this.subCat,
  }) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  // TextEditingController _catController = TextEditingController();

  String? firstname;
  String? lastname;
  String? email;
  Uint8List? _pictuew;

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

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _addressController.text = widget.address;
    Cat = widget.cat;
    AddSubCat();
    Subcat = widget.subCat;
  }


  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
    return "Done";
  }

  void updateValues() async {
    if (_nameController.text.trim().isNotEmpty &&
        _addressController.text.trim().isNotEmpty &&
        Cat.isNotEmpty) {
      String ref = "Change your details";
      if (_pictuew != null) {
        String url = await StorageMethod()
            .uploadImageToStorage("profilePic/", _pictuew!);
        ref = await FirestoreMethods()
            .UpdatePersonalInfo(widget.id, '', '', '', '', url);
      }

      if (widget.name.trim() != _nameController.text.trim()) {
        ref = await FirestoreMethods().UpdatePersonalInfo(
            widget.id, _nameController.text, '', '', '', '');
      }

      if (widget.address.trim() != _addressController.text.trim()) {
        ref = await FirestoreMethods().UpdatePersonalInfo(
            widget.id, '', _addressController.text, '', '', '');
      }

      if (widget.cat != Subcat) {
        if (Subcat.isEmpty) {
          ref = await FirestoreMethods()
              .UpdatePersonalInfo(widget.id, '', '', Cat, Cat, '');
        } else {
          ref = await FirestoreMethods()
              .UpdatePersonalInfo(widget.id, '', '', Subcat, Cat, '');
        }
      }

      addData();
      if (ref == "Success") {
        Navigator.of(context).pop(context);
      } else {
        showSnakBar(ref, context);
      }
    }
  }

  void selectPhoto() async {
    // File? im = await pickVideo(context);
    Uint8List file = await pickImage(ImageSource.gallery);
    setState(() {
      _pictuew = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.cancel),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                               updateValues();
                            },
                            icon: Icon(Icons.check),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Stack(
                        children: [
                          _pictuew != null
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: MemoryImage(_pictuew!),
                                )
                              : CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(widget.url),
                                ),
                          Positioned(
                            bottom: -10,
                            left: 60,
                            child: IconButton(
                              onPressed: () => selectPhoto(),
                              icon: Icon(
                                Icons.add_a_photo_rounded,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'name',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        hintText: 'address',
                      ),
                    ),
                    const SizedBox(height: 20),
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
                    SizedBox(height: 10),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
