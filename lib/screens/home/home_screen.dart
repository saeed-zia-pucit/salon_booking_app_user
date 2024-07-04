import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app/components/bottom_navigationbar.dart';
import 'package:salon_app/models/service_response_model.dart';
import 'package:salon_app/utils/functions.dart';
import 'package:salon_app/view_models/home_view_model.dart';
import 'package:salon_app/widgets/loader_widget.dart';

import '../../components/carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel? homeViewModel;
  List<ServiceResponseModel> selectedServices = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _getData();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    homeViewModel = Provider.of<HomeViewModel>(context);
    super.didChangeDependencies();
  }

  _getData() async {
    await homeViewModel?.getSalonProvider(context);
    final serviceIds = spUtil?.provider.store?.serviceIds;
    for (int i = 0; i < (serviceIds?.length ?? 0); i++) {
      for (int j = 0; j < (spUtil?.services.length ?? 0); j++) {
        if (serviceIds?[i] == spUtil?.services[j].id) {
          selectedServices.add(spUtil?.services[j] ?? ServiceResponseModel());
          break;
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 250,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff721c80),
                              Color.fromARGB(255, 196, 103, 169),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 38, left: 18, right: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.location_solid,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    spUtil?.user.name ?? '',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  const Icon(
                                    CupertinoIcons.person_alt_circle_fill,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ],
                              ),
                              // const SearchBar()
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 150,
                      left: 0,
                      right: 0,
                      child: Carousel(),
                    ),
                  ],
                ),
                // Services view
                Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: Column(
                    children: [
                      const HorizontalText(),
                      (selectedServices.isNotEmpty)
                          ? SizedBox(
                              height: 170,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: selectedServices.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _serviceCard(selectedServices[index]);
                                },
                              ),
                            )
                          : const Text(
                              "No service found",
                              style: TextStyle(
                                  color: Colors.black,
                                  //letterSpacing: 1.07,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )
                    ],
                  ),
                ),
                //  HorizontalText()
                // Specialist View
                // Padding(
                //   padding: const EdgeInsets.only(left: 18, top: 16),
                //   child: Column(
                //     children: [
                //       const Row(
                //         children: [
                //           Text(
                //             "Best Specialists",
                //             style: TextStyle(
                //                 color: Color(0xff721c80),
                //                 //letterSpacing: 1.07,
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 20),
                //           ),
                //           Spacer(
                //             flex: 8,
                //           ),
                //           Text(
                //             "View all",
                //             style: TextStyle(
                //               color: Colors.grey,
                //             ),
                //           ),
                //           Icon(
                //             Icons.double_arrow_rounded,
                //             color: Colors.grey,
                //             size: 18,
                //           ),
                //           Spacer(
                //             flex: 1,
                //           ),
                //         ],
                //       ),
                //       const SizedBox(
                //         height: 18,
                //       ),
                //       StreamBuilder<QuerySnapshot>(
                //         stream: FirebaseFirestore.instance
                //             .collection('workers')
                //             .snapshots(),
                //         builder: (BuildContext context,
                //             AsyncSnapshot<QuerySnapshot> snapshot) {
                //           if (snapshot.connectionState == ConnectionState.waiting) {
                //             return const CircularProgressIndicator(
                //               color: Colors.purple,
                //             );
                //           }
                //           if (snapshot.hasData) {
                //             return SizedBox(
                //               height: 160,
                //               child: ListView.builder(
                //                 scrollDirection: Axis.horizontal,
                //                 itemCount: snapshot.data!.size,
                //                 itemBuilder: (BuildContext context, int index) {
                //                   return Container(
                //                     margin: const EdgeInsets.only(right: 12.0),
                //                     height: 160,
                //                     width: 120,
                //                     decoration: BoxDecoration(
                //                         image: DecorationImage(
                //                             image: NetworkImage(
                //                               snapshot.data?.docs[index]["img"],
                //                             ),
                //                             fit: BoxFit.cover),
                //                         borderRadius: BorderRadius.circular(14)),
                //                     child: Align(
                //                         alignment: Alignment.bottomCenter,
                //                         child: SizedBox(
                //                           width: 80,
                //                           height: 22,
                //                           child: Text(
                //                             snapshot.data?.docs[index]["name"],
                //                             style: const TextStyle(
                //                                 color: Colors.white),
                //                             textAlign: TextAlign.center,
                //                           ),
                //                         )),
                //                   );
                //                 },
                //               ),
                //             );
                //           }

                //           return Container();
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  height: 20,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 220, 218, 218),
                        width: 0.9,
                      ),
                    ),
                  ),
                ),
                // const Padding(
                //   padding:
                //       EdgeInsets.only(top: 12, right: 18, left: 18, bottom: 20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       Column(
                //         children: [
                //           Icon(
                //             Icons.south_america_outlined,
                //             size: 28,
                //             color: Color(0xff721c80),
                //           ),
                //           SizedBox(
                //             height: 10,
                //           ),
                //           Text(
                //             'website',
                //             style: TextStyle(color: Colors.grey),
                //           )
                //         ],
                //       ),
                //       Column(
                //         children: [
                //           Icon(
                //             Icons.discount,
                //             size: 28,
                //             color: Color(0xff721c80),
                //           ),
                //           SizedBox(
                //             height: 10,
                //           ),
                //           Text(
                //             'Offers',
                //             style: TextStyle(color: Colors.grey),
                //           )
                //         ],
                //       ),
                //       Column(
                //         children: [
                //           Icon(
                //             Icons.phone_in_talk_sharp,
                //             size: 28,
                //             color: Color(0xff721c80),
                //           ),
                //           SizedBox(
                //             height: 10,
                //           ),
                //           Text(
                //             'Call',
                //             style: TextStyle(color: Colors.grey),
                //           )
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          Consumer<HomeViewModel>(builder: (context, value, child) {
            return Visibility(
              visible: homeViewModel?.loading ?? false,
              child: const LoaderWidget(),
            );
          }),
        ],
      ),
    );
  }

  Widget _serviceCard(ServiceResponseModel service) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => BottomNavigationComponent(
                          index: 2,
                        )),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10.0, // soften the shadow
                    spreadRadius: 0.5, //extend the shadow
                    offset: Offset(
                      3.0, // Move to right 5  horizontally
                      3.0, // Move to bottom 5 Vertically
                    ),
                  )
                ],

                // image: DecorationImage(
                //     image: NetworkImage(e["img"]), fit: BoxFit.cover)
              ),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: service.image ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.scaleDown,
                ),
                // child: Image.network(
                //   service.image ?? '',
                //   width: 50,
                //   alignment: Alignment.center,
                //   height: 50,
                //   fit: BoxFit.scaleDown,
                // ),
              ),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            service.name ?? '',
            style: const TextStyle(color: Colors.deepPurple),
          ),
        ],
      ),
    );
  }
}

class HorizontalText extends StatelessWidget {
  const HorizontalText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 18, right: 18, bottom: 12),
      child: Row(
        children: [
          Text(
            "Best Services",
            style: TextStyle(
                color: Color(0xff721c80),
                //letterSpacing: 1.07,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          // Spacer(),
          // Text(
          //   "View all",
          //   style: TextStyle(
          //     color: Colors.grey,
          //   ),
          // ),
          // Icon(
          //   Icons.double_arrow_rounded,
          //   color: Colors.grey,
          //   size: 18,
          // )
        ],
      ),
    );
  }
}
