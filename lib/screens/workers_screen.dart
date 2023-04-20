import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../utils/photoview_widget.dart';
import '../utils/profile_text.dart';


class WorkersViewScreen extends StatelessWidget {
  final String url;
  final String name;
  final String address;
  final String phoneNo;
  final String Cat;
  final String adharcard;
  final String city;
  final String local;
  const WorkersViewScreen({Key? key, required this.url, required this.name, required this.address, required this.phoneNo, required this.Cat,required this.adharcard, required this.city, required this.local}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 300,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                   CircleAvatar(
                    radius: 34,
                    backgroundImage: NetworkImage(url),
                  ),
                  SizedBox(height: 10),
                  ProfileText(
                    cat: 'Name',
                    data: name,
                  ),
                  SizedBox(height: 10),
                  ProfileText(
                    cat: 'Address',
                    data: address,
                  ),
                  SizedBox(height: 10),
                  ProfileText(
                    cat: 'Phone No',
                    data: phoneNo,
                  ),
                  SizedBox(height: 10),
                  ProfileText(
                    cat: 'Category',
                    data: Cat,
                  ),

                  SizedBox(height: 10),
                  ProfileText(
                    cat: 'Location',
                    data: "${city!}",
                  ),
                  SizedBox(height: 10),
                  ProfileText(
                    cat: 'Sub Location',
                    data: "${local!}",
                  ),

                  SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    width: 300,
                    child: PhotoViewWidget(url: adharcard,),
                  ),
                  GestureDetector(
                    onTap: () async {
                      FlutterPhoneDirectCaller.callNumber(phoneNo);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(20),
                      child: const Center(
                        child: Text('CALL'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
