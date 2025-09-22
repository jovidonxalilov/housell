import '../../../../core/constants/api_urls.dart';
import '../../../../core/dio/dio_client.dart';
import '../../../../core/error/failure.dart';
import '../model/auth_model.dart';
import '../model/otp_model.dart';

abstract class AuthDatasource {
  Future<OtpModel> sentOtp(String phoneNumber);

  Future<OtpModel> verifyOtp({
    required String phoneNumber,
    required String otp,
  });

  Future<SignUpResponseModel> signUp({required SignUpModel signUp});

  Future<AuthModel> login({required String login, required String password});

  Future<OtpModel> sendResetOtp(String phoneNumber);

  Future<OtpModel> verifyResetOtp({
    required String phoneNumber,
    required String otpReset,
  });

  Future<OtpModel> resetPassword({
    required String phoneNumber,
    required String newPassword,
  });


  factory AuthDatasource(DioClient dioClient) =>
      AuthDatasourceImpl(dioClient: dioClient);
}

class AuthDatasourceImpl implements AuthDatasource {
  final DioClient _dioClient;

  AuthDatasourceImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<OtpModel> sentOtp(String phoneNumber) async {
    try {
      print("🌐 API ga so'rov jo'natilmoqda: $phoneNumber");

      final mainModel = await _dioClient.post(
        ApiUrls.sendOtp,
        data: {"phone": phoneNumber},
      );

      print("📨 API javobi:");
      print("  - ok: ${mainModel.ok}");
      print("  - result: ${mainModel.result}");
      print("  - statusCode: ${mainModel.status}"); // Buni ham qo'shing

      if (mainModel.ok && mainModel.result != null) {
        final otpModel = OtpModel.fromJson(mainModel.result);
        print("✅ OtpModel yaratildi: $otpModel");
        return otpModel;
      }

      // Bu yerda aniqroq xatolik
      throw ApiException(
        "API xatoligi: ok=${mainModel.ok}, result=${mainModel.result}",
      );
    } catch (e) {
      print("💥 sentOtp xatoligi: $e");
      throw Exception("OTP jo'natishda xatolik: $e");
    }
  }

  @override
  Future<OtpModel> sendResetOtp(String phoneNUmber) async {
    try {
      final mainModel = await _dioClient.post(
        ApiUrls.senResetOtp,
        data: {"phone": phoneNUmber},
      );

      if (mainModel.ok && mainModel.result != null) {
        return OtpModel.fromJson(mainModel.result);
      }
      throw ApiException(
        "API xatoligi: ok=${mainModel.ok}, result=${mainModel.result}",
      );
    } catch (e) {
      print("💥 sentOtp xatoligi: $e");
      throw Exception("OTP jo'natishda xatolik: $e");
    }
  }

  @override
  Future<OtpModel> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final mainModel = await _dioClient.post(
        ApiUrls.verifyOtp,
        data: {"phone": phoneNumber, "otp": otp},
      );
      if (mainModel.ok && mainModel.result != null) {
        return OtpModel.fromJson(mainModel.result);
      }
      throw "Otp jonatishda xatolik boldi !";
    } catch (e) {
      throw "Otp jonatishda xatolik boldi !\nError: $e";
    }
  }

  @override
  Future<OtpModel> verifyResetOtp({
    required String phoneNumber,
    required String otpReset,
  }) async {
    try {
      final mainModel = await _dioClient.post(
        ApiUrls.verifyResetOtp,
        data: {"phone": phoneNumber, "otp": otpReset},
      );
      if (mainModel.ok && mainModel.result != null) {
        return OtpModel.fromJson(mainModel.result);
      }
      throw "Otp jonatishda xatolik boldi !";
    } catch (e) {
      throw "Otp jonatishda xatolik boldi !\nError: $e";
    }
  }

  @override
  Future<OtpModel> resetPassword({ required String phoneNumber,
    required String newPassword}) async {
    try {
      final mainModel = await _dioClient.post(ApiUrls.resetPassword,
          data: {"phone": phoneNumber, "newPassword": newPassword});
      if (mainModel.ok && mainModel.result != null) {
        return OtpModel.fromJson(mainModel.result);
      }
      throw "Password xato!";
    } catch (e) {
      throw "Parolni qo'yishda xatolik yuz berdi$e";
    }
  }

  @override
  Future<AuthModel> login({
    required String login,
    required String password,
  }) async {
    try {
      print('Login attempt with: $login');

      final main = await _dioClient.post(
        ApiUrls.login,
        data: {'phone': login, 'password': password},
      );

      print('Response status: ${main.status}');
      print('Response ok: ${main.ok}');
      print('Response result: ${main.result}');

      if (main.ok && main.result != null) {
        if (main.result is Map<String, dynamic>) {
          // LoginResponseModel ni ishlatamiz
          return AuthModel.fromJson(main.result as Map<String, dynamic>);
        } else {
          throw "Response format noto'g'ri: ${main.result.runtimeType}";
        }
      }

      throw "Login muvaffaqiyatsiz";
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  @override
  Future<SignUpResponseModel> signUp({required SignUpModel signUp}) async {
    try {
      final main = await _dioClient.post(ApiUrls.signUp, data: signUp.toJson());
      if (main.ok && main.result != null) {
        return SignUpResponseModel.fromJson(main.result);
      }
      throw "Ro'yxatdan o'tish malumotlari xato";
    } catch (e) {
      throw "Ro'yxatdan o'tishda xatolik yuz berdi: $e";
    }
  }
}
