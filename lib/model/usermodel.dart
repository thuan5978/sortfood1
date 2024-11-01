class UserModel {
  int? userId; 
  String? userName;
  String? phone;
  String img;
  String? address;
  String? email;
  String? password;
  String? position;

  UserModel({
    required this.userId,
    required this.userName,
    required this.email,
    this.phone = 'No phone',
    this.img = '',
    this.address = 'No location',
    this.password,
    this.position,
  });

  
  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      userId: json['UserID'] ?? 0,
      userName: json['UserName'] ?? 'No Name',
      email: json['Email'] ?? 'No email',
      phone: json['Phone'] ?? 'No phone',
      img: json['Image'] ?? '',
      address: json['Address'] ?? 'No location',
      password: json['Password'],
      position: json['Position']
    );
  }

  
  Map<dynamic, dynamic> toJson() {
    return {
      'UserID': userId,
      'UserName': userName,
      'Email': email,
      'Phone': phone,
      'Image': img,
      'Address': address,
      'Password': password,
      'Position': position,
    };
  }

  
}

