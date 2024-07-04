
class ProviderResponseModel {
  String? email;
  String? name;
  String? uid;
  UserStore? store;

  ProviderResponseModel({this.email, this.name, this.uid, this.store});

  ProviderResponseModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    uid = json['uid'];
    store =
        json['store'] != null ? new UserStore.fromJson(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['uid'] = this.uid;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    return data;
  }
}

class UserStore {
  String? cityName;
  String? countryCode;
  List<String>? coverImages;
  String? displayName;
  String? email;
  double? latitude;
  double? longitude;
  String? phone;
  List<int>? serviceIds;
  String? streetAddress;
  String? streetName;
  String? zipCode;
  List<WorkingDays>? days;
  SlotModel? availableSlot;

  UserStore(
      {this.cityName,
      this.countryCode,
      this.coverImages,
      this.displayName,
      this.email,
      this.latitude,
      this.longitude,
      this.phone,
      this.serviceIds,
      this.streetAddress,
      this.streetName,
      this.zipCode,
      this.days,
      this.availableSlot});

  UserStore.fromJson(Map<String, dynamic> json) {
    cityName = json['city_name'];
    countryCode = json['country_code'];
    coverImages = json['cover_images'].cast<String>();
    displayName = json['display_name'];
    email = json['email'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phone = json['phone'];
    serviceIds = json['service_ids'].cast<int>();
    streetAddress = json['street_address'];
    streetName = json['street_name'];
    zipCode = json['zip_code'];
    if (json['time_slot'] != null) {
      availableSlot = SlotModel.fromJson(json['time_slot']);
    }
    if (json['days'] != null) {
      days = <WorkingDays>[];
      json['days'].forEach((v) {
        days!.add(new WorkingDays.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_name'] = this.cityName;
    data['country_code'] = this.countryCode;
    data['cover_images'] = this.coverImages;
    data['display_name'] = this.displayName;
    data['email'] = this.email;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['phone'] = this.phone;
    data['service_ids'] = this.serviceIds;
    data['street_address'] = this.streetAddress;
    data['street_name'] = this.streetName;
    data['zip_code'] = this.zipCode;
    if (this.days != null) {
      data['days'] = this.days!.map((v) => v.toJson()).toList();
    }
    if (availableSlot != null) {
      data['time_slot'] = availableSlot?.toJson();
    }
    return data;
  }
}

class WorkingDays {
  String? dayName;
  List<String>? finishesAt;
  List<String>? startsAt;

  WorkingDays({this.dayName, this.finishesAt, this.startsAt});

  WorkingDays.fromJson(Map<String, dynamic> json) {
    dayName = json['day_name'];
    if (json['finishes_at'] != null) {
      finishesAt = json['finishes_at'].cast<String>();
    }
    if (json['starts_at'] != null) {
      startsAt = json['starts_at'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day_name'] = this.dayName;
    data['finishes_at'] = this.finishesAt;
    data['starts_at'] = this.startsAt;
    return data;
  }
}


class SlotModel {
  int? id;
  String? name;

  SlotModel({this.name, this.id});

  SlotModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}

