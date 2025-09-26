import 'dart:convert';

class ProfileModel {
  final String? id;
  final String name;
  final String surname;
  final String? image;  // nullable qildim
  final String? email;  // nullable qildim
  final String phone;
  final String password;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int freeListingsRemaining;

  ProfileModel({
    this.id,
    required this.name,
    required this.surname,
    this.image,  // nullable
    this.email,  // nullable
    required this.phone,
    required this.password,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.freeListingsRemaining,
  });



  factory ProfileModel.fromMap(Map<String, dynamic> json) {
    try {
      return ProfileModel(
        // String fieldlar uchun xavfsiz parsing
        id: json["id"]?.toString() ?? '',
        name: json["name"]?.toString() ?? '',
        surname: json["surname"]?.toString() ?? '',
        phone: json["phone"]?.toString() ?? '',
        password: json["password"]?.toString() ?? '',
        role: json["role"]?.toString() ?? '',

        // Nullable fieldlar
        image: json["image"]?.toString(),
        email: json["email"]?.toString(),

        // DateTime parsing xavfsiz
        createdAt: _parseDateTime(json["createdAt"]) ?? DateTime.now(),
        updatedAt: _parseDateTime(json["updatedAt"]) ?? DateTime.now(),

        // Int parsing xavfsiz
        freeListingsRemaining: _parseInt(json["freeListingsRemaining"]) ?? 0,
      );
    } catch (e) {
      print('ProfileModel.fromMap error: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  // DateTime ni xavfsiz parse qilish
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    try {
      if (value is String) {
        return DateTime.parse(value);
      }
      if (value is int) {
        // Unix timestamp bo'lsa
        return DateTime.fromMillisecondsSinceEpoch(value * 1000);
      }
    } catch (e) {
      print('DateTime parse error: $e, value: $value');
    }
    return null;
  }

  // Int ni xavfsiz parse qilish
  static int? _parseInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);

    return null;
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "surname": surname,
    "image": image,
    "email": email,
    "phone": phone,
    "password": password,
    "role": role,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "freeListingsRemaining": freeListingsRemaining,
  };

  // Copy with method - yangilash uchun foydali
  ProfileModel copyWith({
    String? id,
    String? name,
    String? surname,
    String? image,
    String? email,
    String? phone,
    String? password,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? freeListingsRemaining,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      image: image ?? this.image,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      freeListingsRemaining: freeListingsRemaining ?? this.freeListingsRemaining,
    );
  }

  @override
  String toString() {
    return 'ProfileModel(id: $id, name: $name, surname: $surname, email: $email, phone: $phone, role: $role)';
  }
}

// Foydalanish namunasi

// Test uchun
