// ignore: unused_import
import 'dart:convert';

class ProfileModel {
  final String? id;
  final String? name;        // ✅ nullable qildik
  final String? surname;     // ✅ nullable qildik
  final String? image;
  final String? email;
  final String? phone;
  final String? password;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? freeListingsRemaining;
  final int? rating;
  final int? comment;

  ProfileModel({
    this.id,
    this.name,        // ✅ required olib tashladik
    this.surname,     // ✅ required olib tashladik
    this.image,
    this.email,
    this.phone,
    this.password,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.freeListingsRemaining,
    this.rating,
    this.comment
  });

  factory ProfileModel.fromMap(Map<String, dynamic> json) {
    try {
      return ProfileModel(
        id: json["id"]?.toString(),
        name: json["name"]?.toString(),      // ✅ null bo'lishi mumkin
        surname: json["surname"]?.toString(), // ✅ null bo'lishi mumkin
        phone: json["phone"]?.toString(),
        password: json["password"]?.toString(),
        role: json["role"]?.toString(),
        image: json["image"]?.toString(),
        email: json["email"]?.toString(),
        createdAt: _parseDateTime(json["createdAt"]),
        updatedAt: _parseDateTime(json["updatedAt"]),
        freeListingsRemaining: _parseInt(json["freeListingsRemaining"]),
        rating: _parseInt(json["averageRating"]),
        comment: _parseInt(json["comments"])
      );
    } catch (e) {
      print('ProfileModel.fromMap error: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      if (value is String) {
        return DateTime.parse(value);
      }
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value * 1000);
      }
    } catch (e) {
      print('DateTime parse error: $e, value: $value');
    }
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    // Faqat null bo'lmagan qiymatlarni qo'shish
    if (id != null) map["id"] = id;
    if (name != null) map["name"] = name;
    if (surname != null) map["surname"] = surname;
    if (image != null) map["image"] = image;
    if (email != null) map["email"] = email;
    if (phone != null) map["phone"] = phone;
    if (rating != null) map["averageRating"] = rating;
    if (comment != null) map["comments"] = comment;
    if (password != null) map["password"] = password;
    if (role != null) map["role"] = role;
    if (createdAt != null) map["createdAt"] = createdAt!.toIso8601String();
    if (updatedAt != null) map["updatedAt"] = updatedAt!.toIso8601String();
    if (freeListingsRemaining != null) map["freeListingsRemaining"] = freeListingsRemaining;

    return map;
  }

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
