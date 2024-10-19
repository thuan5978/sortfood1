class Users {
  int? id;
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
      id: (json['ID'] is int) ? json['ID'] : null,
      name: json['Name'] ?? 'No Name',
      phone: json['Phone'] ?? 'No phone',
      img: json['Image'] ?? '',
      address: json['Address'] ?? 'No location',
      email: json['Email'] ?? 'No email',
      password: json['Password'] ?? 'No password',
    );
  }
}
