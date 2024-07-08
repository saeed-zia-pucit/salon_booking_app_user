import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app/controller/auth_controller.dart';
import 'package:salon_app/screens/profile/my_order_screen.dart';

import 'package:salon_app/utils/functions.dart';
import 'package:salon_app/view_models/home_view_model.dart';
import 'package:salon_app/widgets/horizontal_line.dart';
import 'package:salon_app/widgets/loader_widget.dart';

class ProfileScreen extends StatefulWidget {
  // final User? user;
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> implements Presenter {
  late HomeViewModel homeViewModel;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getBookings();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    homeViewModel = Provider.of<HomeViewModel>(context);
    super.didChangeDependencies();
  }

  getBookings() async {
    await homeViewModel.getUserBookings(context, this);
  }

  @override
  Widget build(BuildContext context) {
    final user = spUtil?.user;
    //print(user);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 40),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   "My Profile",
                  //   style: TextStyle(
                  //       color: Color(0xff721c80),
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 32),
                  // ),
                  // const SizedBox(
                  //   height: 12.0,
                  // ),
                  // const HorizontalLine(),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        foregroundImage: NetworkImage(user?.imageUrl ?? ''),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.name ?? '',
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(user?.email ?? '',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MyOrderScreen()));
                    },
                    child: SectionCard(
                      header: "My orders",
                      desc: homeViewModel.userBookings.length == 1
                          ? "1 order "
                          : "${homeViewModel.userBookings.length} orders",
                    ),
                  ),
                  // const SectionCard(
                  //   header: "Shipping address",
                  //   desc:
                  //       "Robert Robertson, 1234 NW Bobcat Lane, St. Robert, MO 65584-5678.",
                  // ),
                  // const SectionCard(
                  //   header: "Payments method",
                  //   desc: "Visa **34",
                  // ),
                  // const SectionCard(
                  //   header: "Promocodes",
                  //   desc: "You have special offers",
                  // ),
                  const SectionCard(
                    header: "My reviews",
                    desc: "Reviews for 4 barbers",
                  ),
                  const SectionCard(
                    header: "Settings",
                    desc: "Notification, password",
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Authentication.signOut(context: context);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Logout",
                          style: TextStyle(color: Colors.red, fontSize: 22),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<HomeViewModel>(builder: (context, value, child) {
            return Visibility(
              visible: homeViewModel.loading,
              child: const LoaderWidget(),
            );
          }),
        ],
      ),
    );
  }

  @override
  void onClick(String? action) {}
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
