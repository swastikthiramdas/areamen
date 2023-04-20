import 'package:areamen/screens/all_workers_screen.dart';
import 'package:flutter/material.dart';

class SubCatScreen extends StatefulWidget {
  final cats;
  final local;

  SubCatScreen({Key? key, required this.cats, required this.local})
      : super(key: key);

  @override
  State<SubCatScreen> createState() => _SubCatScreenState();
}

class _SubCatScreenState extends State<SubCatScreen> {
  List SubCatList = [];

  @override
  void initState() {
    super.initState();
    setSubCat();
  }

  void setSubCat() async {
    setState(() {
      if (widget.cats == 'Mechanic') {
        SubCatList = <String>['Bike', 'Cycle', 'Car'];
      } else if (widget.cats == 'Appliances Repair') {
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
      } else if (widget.cats == 'Furniture Repair') {
        SubCatList = <String>['Carpenters', 'Pepperfry'];
      } else {
        SubCatList = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'SubCat',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: GridView.builder(
        itemCount: SubCatList.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => AllWorkerScreen(
                        cat: SubCatList[index],
                        local: widget.local,
                      )),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              width: 200,
              height: 180,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  SubCatList[index],
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  maxLines: 2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
