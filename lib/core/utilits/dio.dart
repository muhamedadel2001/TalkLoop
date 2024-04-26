import 'package:dio/dio.dart';

class MyDio {
  static Dio? dio;

  static dioInit() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://fcm.googleapis.com/fcm/',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  static Future<Response> postData(
      {required String endPoint, Map<String, dynamic>? data}) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer AAAAimIK08k:APA91bFCZrsxPzu63tKq1tjrqPWnlcBZ9uu0ONipJnPG2rOFlTlH8jIWcUY0wO2AXPeIAa738Vazey1czEWPy4Z_7w5_hDbaIcC6uXmheR37FSqvoaPNJxQb-X-o6ddJ13Utg2TL7B__"
    };
    return await dio!.post(
      endPoint,
      data: data,
    );
  }
}
