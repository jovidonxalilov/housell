class ResetPassword {
  final String newPassword;
  final String phoneNumber;
  final String? id;

  ResetPassword({
    required this.newPassword,
    required this.phoneNumber,
    this.id
  });
}