class BookingModel {
  User? user;
  Provider? provider;
  List<int>? services;
  List<String>? timeSlots;
  String? bookingOn;

  BookingModel(
      {this.user,
      this.provider,
      this.services,
      this.timeSlots,
      this.bookingOn});

  BookingModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    provider = json['provider'] != null
        ? Provider.fromJson(json['provider'])
        : null;
    services = json['services'].cast<int>();
    timeSlots = json['time_slots'].cast<String>();
    bookingOn = json['booking_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    data['services'] = services;
    data['time_slots'] = timeSlots;
    data['booking_on'] = bookingOn;
    return data;
  }
}

class User {
  String? userId;
  String? name;
  String? email;
  String? profileImage;

  User({this.userId, this.name, this.email, this.profileImage});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['profile_image'] = profileImage;
    return data;
  }
}

class Provider {
  String? providerId;
  String? name;
  String? email;
  String? profileImage;

  Provider({this.providerId, this.name, this.email, this.profileImage});

  Provider.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
    name = json['name'];
    email = json['email'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['provider_id'] = providerId;
    data['name'] = name;
    data['email'] = email;
    data['profile_image'] = profileImage;
    return data;
  }
}