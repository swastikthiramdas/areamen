import 'package:areamen/screens/workers_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class AllWorkerScreen extends StatefulWidget {
  final cat;
  final local;

  AllWorkerScreen({Key? key, required this.cat, required this.local})
      : super(key: key);

  @override
  State<AllWorkerScreen> createState() => _AllWorkerScreenState();
}

class _AllWorkerScreenState extends State<AllWorkerScreen> {
  String value = "";
  String currentlocation = "";
  bool showlocation = false;

  Widget HandymanView(final data) {
    print(widget.local);
    return Container(
      height: 900,
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 34,
            backgroundImage: NetworkImage(data['profileUrl'].toString()),
          ),
          const SizedBox(height: 10),
          Text(
            data['name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                data['subCat'],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),
              Text(
                data['local'].toString().isEmpty ? "Asangaon" : data['local'],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: MaterialButton(
              onPressed: () {
                FlutterPhoneDirectCaller.callNumber(data['phone']);
              },
              color: Colors.blueAccent,
              child: const Text('Call'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.cat,
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('subCat', isEqualTo: widget.cat)
            .where('local', isEqualTo: widget.local)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<dynamic, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return Container();
          }
          return SafeArea(
            child: snapshot.data!.docs.length != 0
                ? GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index].data();
                      if (value.trim().isEmpty) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => WorkersViewScreen(
                                      url: data['profileUrl'],
                                      name: data['name'],
                                      address: data['address'],
                                      phoneNo: data['phone'],
                                      Cat: data['subCat'],
                                      adharcard: data['adharCardUrl'],
                                      city: data['city'],
                                      local: data['local'].toString().isEmpty
                                          ? "Asangaon"
                                          : data['local'],
                                    ))));
                          },
                          child: HandymanView(data),
                        );
                      }
                      if (data['local']
                          .toString()
                          .toLowerCase()
                          .startsWith(value.toLowerCase())) {
                        return InkWell(
                          onTap: () {},
                          child: HandymanView(data),
                        );
                      }
                      return Container();
                    },
                  )
                : const Center(
                    child: Text(
                      'No Data Available',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
