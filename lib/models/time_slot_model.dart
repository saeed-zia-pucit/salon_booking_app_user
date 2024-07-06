class TimeSlotModel {
  String? name;
  bool? isSelected;
  bool? isBooked;

  TimeSlotModel({this.name, this.isSelected = false, this.isBooked = false});

  TimeSlotModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
