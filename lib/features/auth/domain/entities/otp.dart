class VerifyOtpModel {
  final String otp;
  final String phoneNumber;
  final String? id;

  VerifyOtpModel({
    this.id,
    required this.otp,
    required this.phoneNumber,
  });
}