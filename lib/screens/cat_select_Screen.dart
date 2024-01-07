import 'package:areamen/screens/customer_screen.dart';
import 'package:areamen/screens/worker_details.dart';
import 'package:flutter/material.dart';

class SelectCatScreen extends StatefulWidget {
  final phoneNumber;

  SelectCatScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<SelectCatScreen> createState() => _SelectCatScreenState();
}

class _SelectCatScreenState extends State<SelectCatScreen> {
  Widget SelectCat(bool isHandyman) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: isHandyman
                  ? const AssetImage('images/handyman.png')
                  : const AssetImage('images/customer.png'),
            ),
            border: Border.all(
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          isHandyman ? 'Handyman' : 'Customer',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Select Category',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => WorkerDetailScreen(
                              phoneNumber: widget.phoneNumber,
                            ))),
                  );
                },
                child: SelectCat(true),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => CustomerScreen(
                                phoneNumber: widget.phoneNumber,
                              ))));
                },
                child: SelectCat(false),
              ),
            ],
          )
        ],
      ),
    );
  }
}
