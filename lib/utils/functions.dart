import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon_app/utils/sp_utils.dart';

SpUtil? spUtil;

init() async {
  spUtil = await SpUtil.getInstance();
}

abstract class Presenter {
  void onClick(
    String? action,
  );
}

abstract class PresenterWithValue {
  void onClickWithValue(String action, dynamic value);
}

List<String> generateTimeSlots(String startTime, String endTime, int minutes) {
  final DateFormat timeFormat = DateFormat('HH:mm');
  final Duration slotDuration = Duration(minutes: minutes);

  DateTime start = timeFormat.parse(startTime);
  DateTime end = timeFormat.parse(endTime);

  List<String> timeSlots = [];

  while (start.isBefore(end)) {
    final slotStart = timeFormat.format(start);
    final slotEnd = timeFormat.format(start.add(slotDuration));

    if (start.add(slotDuration).isAfter(end)) {
      break;
    }

    timeSlots.add('$slotStart - $slotEnd');
    start = start.add(slotDuration);
  }

  return timeSlots;
}

void showError(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

showPopup(BuildContext context,
    {required String? title,
    required String? description,
    required VoidCallback? onConfirm}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
        titlePadding: const EdgeInsets.only(top: 25.0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Text(
          title ?? '',
          style: const TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        content: Text(
          description ?? '',
          style: const TextStyle(fontSize: 16.0, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(bottom: 20.0),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200], // background (button) color
              foregroundColor: Colors.black, // text color
            ),
            onPressed: onConfirm,
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

String getFormattedDate(DateTime date) {
  String formattedDate = DateFormat('yyyy-MM-dd').format(date);
  return formattedDate;
}


String formatDateString(String dateString) {
  // Parse the input date string
  DateTime parsedDate = DateTime.parse(dateString);

  // Define the desired output format
  DateFormat formatter = DateFormat('dd MMMM yyyy');

  // Format the parsed date
  String formattedDate = formatter.format(parsedDate);

  return formattedDate;
}


String formatTimeString(String timeString) {
  // Parse the input time string
  DateTime parsedTime = DateFormat('HH:mm').parse(timeString);

  // Define the desired output format
  DateFormat formatter = DateFormat('hh:mm a');

  // Format the parsed time
  String formattedTime = formatter.format(parsedTime);

  return formattedTime;
}
