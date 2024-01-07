import 'package:areamen/models/user_model.dart';
import 'package:areamen/provider/user_provider.dart';
import 'package:areamen/screens/profile_edit_screen.dart';
import 'package:areamen/utils/profile_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({Key? key}) : super(key: key);

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel _user = Provider.of<UserProvider>(context).getUser;
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
              width: 250,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => ProfileEditScreen(
                                      url: _user.profileUrl!,
                                      id: _user.uid!,
                                      name: _user.name!,
                                      address: _user.address!,
                                      cat: _user.mainCat!, subCat: _user.subCat!,
                                    ))));
                          },
                          icon: const Icon(Icons.edit_outlined),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  _user.profileUrl!.isEmpty
                      ? CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.redAccent,
                        )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(_user.profileUrl!.toString()),
                        ),
                  SizedBox(height: 10),
                  ProfileText(
                    cat: 'Name',
                    data: _user.name!,
                  ),
                  SizedBox(height: 10),
                  _user.address! != '' ? SizedBox(
                    width: 240,
                    child: ProfileText(
                      cat: 'Address',
                      data: _user.address!,
                    ),
                  ) : SizedBox(),
                  SizedBox(height: 10),
                  ProfileText(
                    cat: 'Phone No',
                    data: _user.phone!,
                  ),
                  SizedBox(height: 10),
                  _user.subCat! != '' ? ProfileText(
                    cat: 'Category',
                    data: _user.subCat!,
                  ) : SizedBox(),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 240,
                    child: ProfileText(
                      cat: 'Location',
                      data: "${_user.city!} ${_user.local!}",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
