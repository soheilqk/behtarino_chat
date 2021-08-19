import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HttpClient {
  final _dio = Dio();
  final _baseUrl = 'https://factor.behtarino.com/';

  HttpClient(BuildContext context, {bool logger = false}) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = 20000;
    _dio.options.sendTimeout = 20000;
    _dio.options.receiveTimeout = 20000;

    _dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        requestHeader: true,
      ),
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        if (error.message.contains("SocketException: Failed host lookup:")) {
          print('context $context');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[600],
              content: Text(
                'عدم اتصال به اینترنت',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
          return handler.reject(error);
        } else {
          return handler.next(error);
        }
      },
    ));
  }

  Future<Response> get(String endPoint, {Map<String, dynamic>? params}) async {
    Response response;

    try {
      response = await _dio.get(
        endPoint,
        queryParameters: params,
      );
    } on DioError catch (error) {
      throw error;
    }

    return response;
  }

  Future<Response> post(String endPoint, {Map<String, dynamic>? data}) async {
    Response response;

    try {
      response = await _dio.post(endPoint, data: data);
    } on DioError catch (error) {
      throw error;
    }

    return response;
  }

  Future<Response> put(String endPoint, {Map<String, dynamic>? data}) async {
    Response response;

    try {
      response = await _dio.put(endPoint, data: data);
    } on DioError catch (error) {
      throw error;
    }

    return response;
  }

  Future<Response> delete(String endPoint) async {
    Response response;
    try {
      response = await _dio.delete(endPoint);
    } on DioError catch (error) {
      throw error;
    }
    return response;
  }

  initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          print(error);
          print('[onError] ${error.message}');
        },
        onRequest: (options, handler) {
          print(
              '[onRequest] ${options.method} ${options.baseUrl}${options.path} ${options.data}');
        },
        onResponse: (response, handler) {
          print('[onResponse] ${response.data}');
          print(response);
        },
      ),
    );
  }
}
