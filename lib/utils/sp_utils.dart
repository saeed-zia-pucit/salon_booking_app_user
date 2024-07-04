//shared_preferences
import 'dart:convert';

import 'package:salon_app/models/provider_response_model.dart';
import 'package:salon_app/models/service_response_model.dart';
import 'package:salon_app/models/user_response_model.dart';
import 'package:salon_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  static SpUtil? _instance;
  static Future<SpUtil?> get instance async {
    return await getInstance();
  }

  static SharedPreferences? _spf;

  SpUtil._();

  Future _init() async {
    _spf = await SharedPreferences.getInstance();
  }

  static Future<SpUtil?> getInstance() async {
    if (_instance == null) {
      _instance = SpUtil._();
      await _instance!._init();
    }
    return _instance;
  }

  static bool _beforCheck() {
    if (_spf == null) {
      return true;
    }
    return false;
  }

  bool hasKey(String key) {
    Set keys = getKeys()!;
    return keys.contains(key);
  }

  Set<String>? getKeys() {
    if (_beforCheck()) return null;
    return _spf!.getKeys();
  }

  get(String key) {
    if (_beforCheck()) return null;
    return _spf!.get(key);
  }

  getString(String key) {
    if (_beforCheck()) return "";
    return _spf!.getString(key);
  }

  Future<bool>? putString(String key, String? value) {
    if (_beforCheck()) return null;
    return _spf!.setString(key, value!);
  }

  bool? getBool(String key) {
    if (_beforCheck()) return null;
    return _spf!.getBool(key);
  }

  Future<bool>? putBool(String key, bool value) {
    if (_beforCheck()) return null;
    return _spf!.setBool(key, value);
  }

  int? getInt(String key) {
    if (_beforCheck()) return null;
    return _spf!.getInt(key);
  }

  Future<bool>? putInt(String key, int value) {
    if (_beforCheck()) return null;
    return _spf!.setInt(key, value);
  }

  double? getDouble(String key) {
    if (_beforCheck()) return null;
    return _spf!.getDouble(key);
  }

  Future<bool>? putDouble(String key, double value) {
    if (_beforCheck()) return null;
    return _spf!.setDouble(key, value);
  }

  List<String>? getStringList(String key) {
    return _spf!.getStringList(key);
  }

  Future<bool>? putStringList(String key, List<String> value) {
    if (_beforCheck()) return null;
    return _spf!.setStringList(key, value);
  }

  dynamic getDynamic(String key) {
    if (_beforCheck()) return null;
    return _spf!.get(key);
  }

  Future<bool>? remove(String key) {
    if (_beforCheck()) return null;
    return _spf!.remove(key);
  }

  Future<bool>? clear() {
    if (_beforCheck()) return null;
    return _spf!.clear();
  }



  List<ServiceResponseModel> get services {
    final serviceJson = getString(keyServices);
    if (serviceJson == null || serviceJson.isEmpty) {
      return []; // Return empty list if no data or empty string
    }
    final List<dynamic> decodedServices = json.decode(serviceJson);
    return decodedServices.map((service) => ServiceResponseModel.fromJson(service)).toList();
  }
  set services(List<ServiceResponseModel> servicesToSave) {
    final String encodedServices = json.encode(servicesToSave.map((service) => service.toJson()).toList());
    putString(keyServices, encodedServices);
  }



  UserResponseModel get user {
    var userJson = getString(userKey);
    if (userJson == null) {
      return UserResponseModel();
    }
    return UserResponseModel.fromJson(json.decode(userJson));
  }
  set user(UserResponseModel userToSave) {
    putString(userKey, json.encode(userToSave.toJson()));
  }


  ProviderResponseModel get provider {
    var providerJson = getString(providerKey);
    if (providerJson == null) {
      return ProviderResponseModel();
    }
    return ProviderResponseModel.fromJson(json.decode(providerJson));
  }
  set provider(ProviderResponseModel providerToSave) {
    putString(providerKey, json.encode(providerToSave.toJson()));
  }
}
