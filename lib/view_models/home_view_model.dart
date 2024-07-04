import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:salon_app/models/provider_response_model.dart';
import 'package:salon_app/utils/firebase_services.dart';
import 'package:salon_app/utils/functions.dart';

class HomeViewModel extends ChangeNotifier {
  // Login
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  //Get All Affliated Campus
  ProviderResponseModel _providerResponseModel = ProviderResponseModel();
  ProviderResponseModel get providerResponseModel => _providerResponseModel;
  set providerResponseModel(ProviderResponseModel value) {
    _providerResponseModel = value;
    notifyListeners();
  }

  Future<void> getSalonProvider(BuildContext context) async {
    try {
      setLoading(true);
      providerResponseModel = await FirebaseServices.getSalonProvider(context);
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
}
