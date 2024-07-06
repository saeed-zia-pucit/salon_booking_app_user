class BookingModel {
  String? bookingOn;
  String? providerId;
  List<int>? services;
  String? userId;
  List<String>? timeSlots;

  BookingModel(
      {this.bookingOn,
      this.providerId,
      this.services,
      this.userId,
      this.timeSlots});

  BookingModel.fromJson(Map<String, dynamic> json) {
    bookingOn = json['booking_on'];
    providerId = json['provider_id'];
    services = json['services'].cast<int>();
    userId = json['user_id'];
    timeSlots = json['time_slots'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_on'] = bookingOn;
    data['provider_id'] = providerId;
    data['services'] = services;
    data['user_id'] = userId;
    data['time_slots'] = timeSlots;
    return data;
  }
}