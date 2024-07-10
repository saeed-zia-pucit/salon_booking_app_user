import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:salon_app/utils/functions.dart';
import 'package:salon_app/view_models/home_view_model.dart';
import 'package:salon_app/widgets/horizontal_line.dart';
import 'package:salon_app/widgets/loader_widget.dart';

class MyOrderScreen extends StatefulWidget {
  // final User? user;
  const MyOrderScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> implements Presenter {
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
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
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
                child: homeViewModel.userBookings.isNotEmpty
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    // ClipRRect(
                                    //   borderRadius: const BorderRadius.all(
                                    //       Radius.circular(8.0)),
                                    //   child: CachedNetworkImage(
                                    //       width:
                                    //           MediaQuery.of(context).size.width,
                                    //       fit: BoxFit.cover,
                                    //       imageUrl: homeViewModel
                                    //               .userBookings[index]
                                    //               .provider
                                    //               ?.profileImage ??
                                    //           ''),
                                    // ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 10.0),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(0, 1),
                                                blurRadius: 4.0,
                                                color: Colors.black
                                                    .withOpacity(0.45))
                                          ],
                                          color: Colors.cyan[400],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8.0))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            homeViewModel.userBookings[index]
                                                    .provider?.name ??
                                                '',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                  "Reservation confirmed",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Text(
                                                "${formatDateString(homeViewModel.userBookings[index].bookingOn ?? '')} ${formatTimeString(homeViewModel.userBookings[index].timeSlots?.first.split("-").first ?? '')}",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 20.0,
                              );
                            },
                            itemCount: homeViewModel.userBookings.length))
                    : const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "No orders found!",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
              )
            ],
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
