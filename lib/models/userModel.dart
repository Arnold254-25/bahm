import 'package:hive/hive.dart';

part 'userModel.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String address;

  @HiveField(4)
  String imageUrl;

  @HiveField(5)
  String? pin;

  @HiveField(6)
  bool biometricEnabled;

  @HiveField(7)
  bool securitySetupCompleted;

  @HiveField(8)
  String uid;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.imageUrl,
    required this.uid,
    this.pin,
    this.biometricEnabled = false,
    this.securitySetupCompleted = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? "User",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      address: json['address'] ?? "",
      imageUrl: json['imageUrl'] ?? 'https://example.com/default_image.png',
      uid: json['uid'] ?? '',
      pin: json['pin'],
      biometricEnabled: json['biometricEnabled'] ?? false,
      securitySetupCompleted: json['securitySetupCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'imageUrl': imageUrl,
      'uid': uid,
      'pin': pin,
      'biometricEnabled': biometricEnabled,
      'securitySetupCompleted': securitySetupCompleted,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? imageUrl,
    String? uid,
    String? pin,
    bool? biometricEnabled,
    bool? securitySetupCompleted,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      uid: uid ?? this.uid,
      pin: pin ?? this.pin,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      securitySetupCompleted: securitySetupCompleted ?? this.securitySetupCompleted,
    );
  }
}
