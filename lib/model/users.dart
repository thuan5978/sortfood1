class Users {
  int? userId;
  String? userName;
  String? phone;
  String? img;
  String? address;
  String? email;
  String? password;
  
  Users({
    this.userId,
    this.userName,
    this.phone,
    this.img,
    this.address,
    this.email,
    this.password,
  });

  factory Users.fromJson(Map<dynamic, dynamic> json) {
    return Users(
      userId: (json['UserID'] is int) ? json['UserID'] : null,
      userName: json['UserName'] ?? 'No Name',
      phone: json['Phone'] ?? 'No phone',
      img: json['Image'] ?? '',
      address: json['Address'] ?? 'No location',
      email: json['Email'] ?? 'No email',
      password: json['Password'] ?? 'No password',
    );
  }

  
  Map<dynamic, dynamic> toJson() {
    return {
      'UserID': userId,
      'UserName': userName,
      'Phone': phone,
      'Image': img,
      'Address': address,
      'Email': email,
      'Password': password,
    };
  }
}