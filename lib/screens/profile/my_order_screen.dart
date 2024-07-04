import 'package:flutter/material.dart';
import 'package:salon_app/controller/auth_controller.dart';

import 'package:salon_app/utils/functions.dart';
import 'package:salon_app/widgets/horizontal_line.dart';

class MyOrderScreen extends StatelessWidget {
  // final User? user;
  const MyOrderScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = spUtil?.user;

    

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Color(0xff721c80),
                  )),
              const SizedBox(
                width: 20,
              ),
              const Text("My Orders",
                  style: TextStyle(
                      color: Color(0xff721c80),
                      fontWeight: FontWeight.bold,
                      fontSize: 24))
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          spUtil?.services[4].image ?? '',
                          width: 80,
                          height: 80,
                          fit: BoxFit.scaleDown,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Hairstyling",
                              style: TextStyle(
                                  color: Color(0xff721c80), fontSize: 18),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text("10:00 AM",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                )),
                          ],
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.grey[700],
                    );
                  },
                  itemCount: 3),
            ),
          )
        ],
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String header;
  final String desc;
  const SectionCard({
    Key? key,
    required this.header,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(
              color: Color(0xff721c80),
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(desc,
            style: TextStyle(
              color: Colors.grey[700],
            )),
        const SizedBox(height: 12),
        const HorizontalLine(),
        const SizedBox(height: 12),
      ],
    );
  }
}
