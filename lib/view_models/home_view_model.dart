import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:salon_app/models/provider_response_model.dart';
import 'package:salon_app/utils/constants.dart';
import 'package:salon_app/utils/firebase_services.dart';
import 'package:salon_app/utils/functions.dart';

class HomeViewModel extends ChangeNotifier {
  // Loading flag for showing loader on screen
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  // Fetch provider details
  ProviderResponseModel _providerResponseModel = ProviderResponseModel();
  ProviderResponseModel get providerResponseModel => _providerResponseModel;
  set providerResponseModel(ProviderResponseModel value) {
    _providerResponseModel = value;
    notifyListeners();
  }

  Future<void> getSalonProvider(BuildContext context) async {
    try {
      setLoading(true);
      providerResponseModel = await FirebaseServices.getSalonProvider();
      spUtil?.provider = providerResponseModel;
      log(providerResponseModel.toJson().toString());
    } catch (e) {
      Future.delayed(Duration.zero, () {
        showError(context, e.toString());
      });
    } finally {
      setLoading(false);
    }
  }

  // Create a new booking
  Future<void> createBooking(BuildContext context, Presenter presenter,
      {required String userId,
      required String providerId,
      required String bookingOn,
      required List<int> services,
      required List<String> timeSlots}) async {
    try {
      setLoading(true);
      await FirebaseServices.createBooking(
          userId: userId,
          providerId: providerId,
          services: services,
          bookingOn: bookingOn,
          timeSlots: timeSlots);
      presenter.onClick(onSuccess);
    } catch (e) {
      Future.delayed(Duration.zero, () {
        showError(context, e.toString());
      });
    } finally {
      setLoading(false);
    }
  }
}
