import 'dart:convert';

class MaklerModel {
  final List<Maklers> data;
  final Meta meta;

  MaklerModel({
    required this.data,
    required this.meta,
  });

  factory MaklerModel.fromJson(String str) => MaklerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MaklerModel.fromMap(Map<String, dynamic> json) => MaklerModel(
    data: List<Maklers>.from(json["data"].map((x) => Maklers.fromMap(x))),
    meta: Meta.fromMap(json["meta"]),
  );

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
    "meta": meta.toMap(),
  };
}

class Maklers {
  final String id;
  final String name;
  final String surname;
  final String phone;
  final String? email;
  final String role;
  final String? image;
  final String bio;
  final List<dynamic> specialties;
  final int yearsOfExperience;
  final List<String> languagesSpoken;
  final List<SocialLink> socialLinks;
  final DateTime createdAt;

  Maklers({
    required this.id,
    required this.name,
    required this.surname,
    required this.phone,
    required this.email,
    required this.role,
    required this.image,
    required this.bio,
    required this.specialties,
    required this.yearsOfExperience,
    required this.languagesSpoken,
    required this.socialLinks,
    required this.createdAt,
  });

  factory Maklers.fromJson(String str) => Maklers.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Maklers.fromMap(Map<String, dynamic> json) => Maklers(
    id: json["id"],
    name: json["name"],
    surname: json["surname"],
    phone: json["phone"],
    email: json["email"],
    role: json["role"],
    image: json["image"],
    bio: json["bio"],
    specialties: List<dynamic>.from(json["specialties"].map((x) => x)),
    yearsOfExperience: json["yearsOfExperience"],
    languagesSpoken: List<String>.from(json["languagesSpoken"].map((x) => x)),
    socialLinks: List<SocialLink>.from(json["socialLinks"].map((x) => SocialLink.fromMap(x))),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "surname": surname,
    "phone": phone,
    "email": email,
    "role": role,
    "image": image,
    "bio": bio,
    "specialties": List<dynamic>.from(specialties.map((x) => x)),
    "yearsOfExperience": yearsOfExperience,
    "languagesSpoken": List<dynamic>.from(languagesSpoken.map((x) => x)),
    "socialLinks": List<dynamic>.from(socialLinks.map((x) => x.toMap())),
    "createdAt": createdAt.toIso8601String(),
  };
}

class SocialLink {
  final String url;
  final String platform;

  SocialLink({
    required this.url,
    required this.platform,
  });

  factory SocialLink.fromJson(String str) => SocialLink.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SocialLink.fromMap(Map<String, dynamic> json) => SocialLink(
    url: json["url"],
    platform: json["platform"],
  );

  Map<String, dynamic> toMap() => {
    "url": url,
    "platform": platform,
  };
}

class Meta {
  final int total;
  final int page;
  final int limit;
  final int lastPage;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.lastPage,
  });

  factory Meta.fromJson(String str) => Meta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Meta.fromMap(Map<String, dynamic> json) => Meta(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    lastPage: json["lastPage"],
  );

  Map<String, dynamic> toMap() => {
    "total": total,
    "page": page,
    "limit": limit,
    "lastPage": lastPage,
  };
}
