import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon_app/components/date_picker.dart';
import 'package:salon_app/models/service_response_model.dart';
import 'package:salon_app/models/time_slot_model.dart';
import 'package:salon_app/utils/constants.dart';
import 'package:salon_app/utils/functions.dart';
import 'package:salon_app/view_models/home_view_model.dart';
import 'package:salon_app/widgets/loader_widget.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> implements Presenter {
  int selectedIndex = 0;

  late HomeViewModel homeViewModel;

  List<TimeSlotModel> timeSlots = [];

  List<ServiceResponseModel> selectedServices = [];
  String? bookingOn; // Date

  @override
  void initState() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    bookingOn = formattedDate;
    log("Initial booking day value: $bookingOn");
    Future.delayed(Duration.zero, () {
      final serviceIds = spUtil?.provider.store?.serviceIds;
      for (int i = 0; i < (serviceIds?.length ?? 0); i++) {
        for (int j = 0; j < (spUtil?.services.length ?? 0); j++) {
          if (serviceIds?[i] == spUtil?.services[j].id) {
            selectedServices.add(spUtil?.services[j] ?? ServiceResponseModel());
            break;
          }
        }
      }

      List<String> slots = [];
      if (spUtil?.provider.store?.availableSlot?.id == 1) {
        // 30 mins
        slots = generateTimeSlots(
            spUtil?.provider.store?.days?.first.startsAt?.first ?? '',
            spUtil?.provider.store?.days?.first.finishesAt?.first ?? '',
            30);
      } else if (spUtil?.provider.store?.availableSlot?.id == 2) {
        // 45 mins
        slots = generateTimeSlots(
            spUtil?.provider.store?.days?.first.startsAt?.first ?? '',
            spUtil?.provider.store?.days?.first.finishesAt?.first ?? '',
            45);
      } else {
        // 1 hour
        slots = generateTimeSlots(
            spUtil?.provider.store?.days?.first.startsAt?.first ?? '',
            spUtil?.provider.store?.days?.first.finishesAt?.first ?? '',
            60);
      }
      if (slots.isNotEmpty) {
        for (var element in slots) {
          timeSlots.add(TimeSlotModel(name: element));
        }
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    homeViewModel = Provider.of<HomeViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // height: 240,
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
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 38, left: 18, right: 18),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Spacer(),
                              Text(
                                "Book Your Appointment",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                            ],
                          ),
                          CustomDatePicker(
                            onDateChanged: (date) {
                              bookingOn = date;
                              log(bookingOn ?? ''); // Output: 2024-07-06
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Available Slots",
                          style: TextStyle(
                              color: Color.fromARGB(255, 45, 42, 42),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        timeSlots.isNotEmpty
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              3, // Number of columns in the grid
                                          crossAxisSpacing: 5.0,
                                          mainAxisSpacing: 5.0,
                                          childAspectRatio: 3 / 1),
                                  itemCount: timeSlots.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        // timeSlots.forEach((element) {
                                        //   element.isSelected = false;
                                        // });
                                        if (timeSlots[index].isSelected ??
                                            false) {
                                          timeSlots[index].isSelected = false;
                                        } else {
                                          timeSlots[index].isSelected = true;
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0,
                                        ),
                                        decoration: BoxDecoration(
                                            color:
                                                timeSlots[index].isSelected ==
                                                        true
                                                    ? Colors.purple
                                                    : Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(14)),
                                            border: Border.all(
                                                color: Colors.purple)),
                                        child: Center(
                                          child: Text(
                                            timeSlots[index].name ?? '',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: timeSlots[index]
                                                            .isSelected ==
                                                        true
                                                    ? Colors.white
                                                    : Colors.purple,
                                                fontSize: 13.0),
                                            // style: TextStyle(color: chip.labelColor),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const Text(
                                "No slot available",
                                style: TextStyle(
                                    color: Colors.black,
                                    //letterSpacing: 1.07,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Select Services",
                          style: TextStyle(
                              color: Color.fromARGB(255, 45, 42, 42),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedServices.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _serviceCard(
                                  selectedServices[index], index);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (selectedServices.any(
                                (element) => element.isSelected == true)) &&
                            (timeSlots
                                .any((element) => element.isSelected == true))
                        ? (() async {
                            List<int> serviceIdList = [];
                            List<String> timeSlotValues = [];
                            for (int i = 0;
                                i < (selectedServices.length);
                                i++) {
                              if (selectedServices[i].isSelected == true) {
                                serviceIdList.add(selectedServices[i].id ?? 0);
                              }
                            }
                            for (int i = 0; i < (timeSlots.length); i++) {
                              if (timeSlots[i].isSelected == true) {
                                timeSlotValues.add(timeSlots[i].name ?? '');
                              }
                            }
                            setState(() {});
                            homeViewModel.createBooking(context, this,
                                userId: spUtil?.user.uid ?? '',
                                providerId: spUtil?.provider.uid ?? '',
                                bookingOn: bookingOn ?? '',
                                services: serviceIdList,
                                timeSlots: timeSlotValues);
                            // var snap = FirebaseFirestore.instance.collection('workers');
                            // List data = [];
                            // snap.doc('G9ZvAbTR9HvoiMChKrTA').get().then((value) {
                            //   setState(() {
                            //     print('snap');
                            //     print(value["booked"]);
                            //     data = value["booked"];
                            //     print(data);
                            //     data.add('value10');
                            //   });
                            // }).then((value) => snap
                            //     .doc('G9ZvAbTR9HvoiMChKrTA')
                            //     .update({
                            //       'booked': data,
                            //     }) // <-- Updated data
                            //     .then((_) => print('Success'))
                            //     .catchError((error) => print('Failed: $error')));
                          })
                        : null,
                    child: Container(
                      margin: const EdgeInsets.only(left: 18, right: 18),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (selectedServices.any(
                                    (element) => element.isSelected == true)) &&
                                (timeSlots.any(
                                    (element) => element.isSelected == true))
                            ? const Color(0xff721c80)
                            : Colors.grey[350],
                        gradient: (selectedServices.any(
                                    (element) => element.isSelected == true)) &&
                                (timeSlots.any(
                                    (element) => element.isSelected == true))
                            ? const LinearGradient(
                                colors: [
                                  Color(0xff721c80),
                                  Color.fromARGB(255, 196, 103, 169),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                      ),
                      child: const Center(
                          child: Text(
                        "Book an appointment",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.bold),
                      )),
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

  _serviceCard(ServiceResponseModel service, int index) {
    return GestureDetector(
      onTap: (() {
        // onClick(index);
        // selectedServices.forEach((element) {
        //   element.isSelected = false;
        // });
        if (service.isSelected ?? false) {
          service.isSelected = false;
        } else {
          service.isSelected = true;
        }
        setState(() {});
      }),
      child: AnimatedContainer(
        duration: const Duration(microseconds: 80),
        curve: Curves.elasticIn,
        margin: const EdgeInsets.only(right: 12.0),
        height: 80,
        width: 80,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: (service.isSelected ?? false)
                ? Border.all(
                    width: 5,
                    color: const Color(0xff721c80),
                  )
                : Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(14)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14)),
              child: CachedNetworkImage(
                imageUrl: service.image ?? '',
                height: 40,
                width: 60,
                fit: BoxFit.scaleDown,
              ),
            ),
            // const Spacer(),
            const SizedBox(height: 5),
            Text(
              service.name ?? "",
              style: const TextStyle(
                color: Color(0xff721c80),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            // Text(
            //   "₹${snapshot.data?.docs[index]["price"] ?? ""}",
            //   style: const TextStyle(
            //     color: Color(0xff721c80),
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            // const Spacer()
          ],
        ),
      ),
    );
  }

  @override
  void onClick(String? action) {
    switch (action) {
      case onSuccess:
        showConfirmationPopup(context,
            title: "Appointment Booked",
            description:
                "Your appointment has been successfully booked. Thank you!",
            onConfirm: () {
          timeSlots.forEach((element) {
            element.isSelected = false;
          });
          selectedServices.forEach((element) {
            element.isSelected = false;
          });
          setState(() {});
          Navigator.pop(context);
        });
        break;
    }
  }
}

class ChipWrapper extends StatelessWidget {
  const ChipWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Chip(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide()),
          label: const Text("10:00 AM"),
          backgroundColor: Colors.white,
        ),
        Chip(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide()),
          label: const Text("10:00 AM"),
          backgroundColor: Colors.white,
        ),
        Chip(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide()),
          label: const Text("10:00 AM"),
          backgroundColor: Colors.white,
        ),
      ],
    );
  }
}

// ElevatedButton(
//     onPressed: () async {
//       var snap = FirebaseFirestore.instance.collection('workers');
//       List data = [];
//       snap.doc('G9ZvAbTR9HvoiMChKrTA').get().then((value) {
//         setState(() {
//           print('snap');
//           print(value["booked"]);
//           data = value["booked"];
//           print(data);
//           data.add('value10');
//         });
//       }).then((value) => snap
//           .doc('G9ZvAbTR9HvoiMChKrTA')
//           .update({
//             'booked': data,
//           }) // <-- Updated data
//           .then((_) => print('Success'))
//           .catchError((error) => print('Failed: $error')));
//     },
//     child: Text("Book"))
