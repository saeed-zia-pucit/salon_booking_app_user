class UserResponseModel {
  String? email;
  String? uid;
  String? name;
  String? imageUrl;

  UserResponseModel({this.email, this.uid, this.name, this.imageUrl});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    uid = json['uid'];
    name = json['name'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    return data;
  }
}