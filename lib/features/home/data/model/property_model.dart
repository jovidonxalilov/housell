import 'dart:convert';
import 'dart:io';

class PropertyModel {
  final List<Datum> data;
  final Datum? datum;
  final int? total;
  final int? page;
  final int? limit;

  PropertyModel({
    required this.data,
     this.total,
    this.datum,
     this.page,
     this.limit,
  });

  // Bu yerda o'zgartirish - Map qabul qiladi
  factory PropertyModel.fromJson(dynamic json) {
    if (json is String) {
      return PropertyModel.fromMap(jsonDecode(json));
    } else if (json is Map<String, dynamic>) {
      return PropertyModel.fromMap(json);
    }
    throw Exception('Invalid JSON format for PropertyModel');
  }

  String toJson() => json.encode(toMap());

  factory PropertyModel.fromMap(Map<String, dynamic> json) {
    final rawData = json["data"];

    List<Datum> parsedData = [];

    if (rawData is List) {
      parsedData = rawData.map((x) => Datum.fromMap(x)).toList();
    } else if (rawData is Map<String, dynamic>) {
      parsedData = [Datum.fromMap(rawData)];
    } else {
      parsedData = [];
    }

    return PropertyModel(
      data: parsedData,
      datum: parsedData.isNotEmpty ? parsedData.first : null, // 🔑
      total: json["total"] ?? 0,
      page: json["page"] ?? 0,
      limit: json["limit"] ?? 10,
    );

  }

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
    "total": total,
    "page": page,
    "limit": limit,
  };
}

class Datum {
  final String? id; // Server uchun null bo'ladi
  final String typeOfSale;
  final String buildingType;
  final String title;
  final String description;
  final String numberOfRooms; // INT ga o'zgartirdik
  final int numberOfBathrooms; // INT ga o'zgartirdik
  final int area; // INT ga o'zgartirdik
  final int floor; // INT ga o'zgartirdik
  final int totalFloors; // INT ga o'zgartirdik
  final String furnishing;
  final int latitude;
  final int longitude;
  final String location;
  final List<String> locatedNear;
  final bool isVip;
  final String? youtubeLink;
  final bool isVerified;
  final String rentalFrequency;
  final String currency;

  final int price;
  final List<Photo> photos;
  final String? ownerId;
  final bool? isPaid;
  final bool? freeListingUsed;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  Datum({
    this.id, // Null bo'lishi mumkin
    required this.typeOfSale,
    required this.buildingType,
    required this.title,
    required this.description,
    required this.numberOfRooms,
    required this.numberOfBathrooms,
    required this.area,
    required this.floor,
    required this.totalFloors,
    required this.furnishing,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.locatedNear,
    this.isVip = false,
    this.youtubeLink,
    this.isVerified = false,
    required this.rentalFrequency,
    required this.currency,
    required this.price,
    required this.photos,
    this.ownerId,
    this.isPaid,
    this.freeListingUsed,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) {
    print("=== DATUM PARSE DEBUG ===");
    print("Kelgan JSON: $json");
    print("Photos turi: ${json['photos']?.runtimeType}");
    print("Photos qiymati: ${json['photos']}");

    return Datum(
      id: json["id"]?.toString(), // ✅ String ga o'tkazish
      typeOfSale: json["typeOfSale"]?.toString() ?? "",
      buildingType: json["buildingType"]?.toString() ?? "",
      title: json["title"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      numberOfRooms: json["NumberOfRooms"]?.toString() ?? "1",
      numberOfBathrooms: _parseToInt(json["NumberOfBathrooms"]),
      area: _parseToInt(json["Area"]),
      floor: _parseToInt(json["floor"]),
      totalFloors: _parseToInt(json["totalFloors"]),
      furnishing: json["furnishing"]?.toString() ?? "",
      latitude: _parseToInt(json["latitude"]),
      longitude: _parseToInt(json["longitude"]),
      location: json["location"]?.toString() ?? "",
      locatedNear: _parseStringList(json["locatedNear"]),
      isVip: json["isVip"] == true,
      youtubeLink: json["youtubeLink"]?.toString(),
      isVerified: json["isVerified"] == true,
      rentalFrequency: json["rentalFrequency"]?.toString() ?? "",
      currency: json["currency"]?.toString() ?? "",
      price: _parseToInt(json["price"]),
      photos: _parsePhotos(json["photos"]), // ✅ Alohida function
      ownerId: json["ownerId"]?.toString(),
      isPaid: json["isPaid"] as bool?,
      freeListingUsed: json["freeListingUsed"] as bool?,
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"].toString())
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"].toString())
          : null,
      user: json["user"] != null ? User.fromMap(json["user"]) : null,
    );
  }

// ✅ Helper functions - Datum class ichiga qo'shing
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  static List<Photo> _parsePhotos(dynamic value) {
    print("📸 Photos parse: $value (${value.runtimeType})");

    if (value == null) return [];

    if (value is List) {
      return value.map((item) {
        try {
          // Agar String bo'lsa
          if (item is String) {
            return Photo(photo: item);
          }
          // Agar Map bo'lsa
          if (item is Map<String, dynamic>) {
            return Photo.fromJson(item);
          }
          print("⚠️ Noma'lum photo format: $item");
          return Photo(photo: item.toString());
        } catch (e) {
          print("❌ Photo parse xatolik: $e");
          return Photo(photo: "");
        }
      }).toList();
    }

    return [];
  }
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      // ID ni faqat null bo'lmasa qo'shamiz
      // if (id != null) "id": id,"sdgetgrthgry"
      "typeOfSale": typeOfSale,
      "buildingType": buildingType,
      "title": title,
      "description": description,
      "NumberOfRooms": numberOfRooms.toString(), // INT
      "NumberOfBathrooms": numberOfBathrooms, // INT
      "Area": area, // INT
      "floor": floor, // INT
      "totalFloors": totalFloors, // INT
      "furnishing": furnishing,
      "latitude": latitude,
      "longitude": longitude,
      "location": location,
      "locatedNear": List<dynamic>.from(locatedNear.map((x) => x)),
      "isVip": isVip,
      if (youtubeLink != null) "youtubeLink": youtubeLink,
      "isVerified": isVerified,
      "rentalFrequency": rentalFrequency,
      "currency": currency,
      "price": price, // INT
      "photos": photos.map((x) => x is String ? x : x.photo).toList(),
    };
  //
  //   {
  //     "typeOfSale": "RENT",
  //   "buildingType": "APARTMENT",
  //   "title": "Beautiful Family House",
  //   "description": "A beautiful family house located in the suburbs with spacious rooms and a large garden.",
  //   "NumberOfRooms": "2",
  //   "NumberOfBathrooms": 1,
  //   "Area": 120,
  //   "floor": 1,
  //   "totalFloors": 3,
  //   "furnishing": "FURNISHED",
  //   "latitude": 0,
  //   "longitude": 0,
  //   "location": "Yunusobod, Bodomzor, 123 MainStreet",
  //   "locatedNear": [
  //   "Hospital,Park, School"
  //   ],
  //   "rentalFrequency": "MONTHLY",
  //   "currency": "UZS",
  //   "price": 3000000,
  //   "photos": [
  //   "houseimage.png",
  //   "houseimage2.png"
  //   ],
  //   "isVip": false,
  //   "youtubeLink": null,
  //   "isVerified": false
  // }


    // Optional fieldlar
    if (ownerId != null) map["ownerId"] = ownerId;
    if (isPaid != null) map["isPaid"] = isPaid;
    if (freeListingUsed != null) map["freeListingUsed"] = freeListingUsed;
    if (createdAt != null) map["createdAt"] = createdAt!.toIso8601String();
    if (updatedAt != null) map["updatedAt"] = updatedAt!.toIso8601String();
    if (user != null) map["user"] = user!.toMap();

    return map;
  }
}

class Photo {
  final String photo; // URL yoki local path sifatida saqlanadi

  Photo({ required this.photo, });

  /// Serverdan JSON kelganda
  factory Photo.fromJson(dynamic json) {
    if (json is String) {
      return Photo(photo: json);
    } else if (json is Map<String, dynamic>) {
      return Photo(photo: json["photo"] ?? "");
    }
    throw ArgumentError("Noto‘g‘ri json format: $json");
  }

  /// Local File sifatida foydalanish uchun
  File get file => File(photo);

  /// Serverga yuborishda
  Map<String, dynamic> toMap() => {'photos': photo};
}



class User {
  final String id;
  final String name;
  final String email;
  final String image;
  final String phone;
  final String surname;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.surname,
    required this.role,
    required this.image,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"] ?? "",
    name: json["name"] ?? "",
    email: json["email"] ?? "",
    image: json["image"] ?? "",
    role: json['role'] ?? "",
    phone: json['phone'] ?? "",
    surname: json['surname'] ?? "",
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "image": image,
    "phone": phone,
    "surname": surname,
    "role": role
  };
}

class Photos {
  final File file; // faqat bitta fayl yuboriladi

  Photos({required this.file});

  Map<String, dynamic> toMap() => {
    "file": file.path, // debug uchun
  };
}

