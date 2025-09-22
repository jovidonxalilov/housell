class OtpModel {
  final String? phone;    // nullable qilamiz
  final String otp;
  final String message;

  OtpModel({
    required this.message,
    required this.otp,
    this.phone,  // required ni olib tashlaymiz
  });

  factory OtpModel.fromJson(Map<String, dynamic> json) {
    return OtpModel(
      message: json['message'] ?? '',  // null bo'lsa bo'sh string
      otp: json['otp'] ?? '',
      phone: json['phone'],  // null bo'lishi mumkin
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'otp': otp,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'OtpModel(phone: $phone, otp: $otp, message: $message)';
  }
}
