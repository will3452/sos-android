import 'package:dio/dio.dart';

final options = BaseOptions(
  baseUrl: 'https://sos-app.elezerk.net/api/',
);

final appDio = Dio(options);