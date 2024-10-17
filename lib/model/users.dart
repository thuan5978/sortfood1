class Users {
  String? id;
  String? name;
  String? phone;
  String? img;
  String? address;
  String? email;
  String? password;

  Users({
    this.id,
    this.name,
    this.phone,
    this.img,
    this.address,
    this.email,
    this.password,
  });

  factory Users.fromJson(Map<dynamic, dynamic> json) {
    return Users(
      id: json['ID'],
      name: json['fields']['Name'] ?? 'No Name',
      phone: json['fields']['Phone'] ?? 'No phone',
      img: json['fields']['Image'] ?? '',
      address: json['fields']['Address'] ?? 'No location',
      email: json['fields']['Email'] ?? 'No email',
      password: json['fields']['Password'] ?? 'No password',
    );
  }
}
