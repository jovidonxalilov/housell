class AuthModel {
  final String accessToken;
  final String refreshToken;
  final Error? error;

  AuthModel({
    required this.accessToken,
    required this.refreshToken,
    this.error,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    try {
      print('LoginResponseModel.fromJson received: $json');

      if (json['accessToken'] == null) {
        throw 'accessToken field mavjud emas';
      }

      if (json['refreshToken'] == null) {
        throw 'refreshToken field mavjud emas';
      }

      return AuthModel(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        error: json['error'] != null
            ? Error.fromJson(json['error'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      print('LoginResponseModel.fromJson error: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      if (error != null) 'error': error!.toString(),
    };
  }
}

class SignUpModel {
  final String name;
  final String surname;
  final String password;
  final String phone;
  final String role;

  SignUpModel({
    required this.name,
    required this.surname,
    required this.password,
    required this.phone,
    required this.role,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      name: json['name'],
      surname: json['surname'],
      password: json['password'],
      phone: json['phone'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'password': password,
      'phone': phone,
      'role': role,
    };
  }
}


class SignUpResponseModel {
  final String id;
  final String name;
  final String surname;
  final String? image;
  final String? email;
  final String phone;
  final String role;
  final String createdAt;
  final String updatedAt;

  SignUpResponseModel({
    required this.id,
    required this.name,
    required this.surname,
    this.image,
    this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      image: json['image'],
      email: json['email'],
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class Error {
  final String message;

  Error({required this.message});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(message: json['message'] ?? '');
  }

  @override
  String toString() {
    return message;
  }
}
