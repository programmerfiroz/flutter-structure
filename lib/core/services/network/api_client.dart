import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_stracture/core/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import '../../utils/logger.dart';
import '../storage/token_manger.dart';
import 'api_checker.dart';
import 'multipart.dart';

class ApiClient {
  final Dio _dio;

  ApiClient() : _dio = Dio() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
      contentType: 'application/json',
      validateStatus: (status) => status! < 500,
    );

    // Add interceptor to dynamically add token to each request
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = TokenManager.getToken() ?? "";

        options.headers["Authorization"] = "Bearer $token";
        options.headers["Content-Type"] = "application/json";

        return handler.next(options);
      },
    ));
  }

  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        bool handleError = false,
        bool showToaster = false,
      }) async {
    try {
      Logger.d('ApiClient() => GET request: $path');
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      Logger.d('ApiClient() => GET response: ${response.data}');
      // return ApiChecker.checkResponse(response);

      if (handleError) {
        return ApiChecker.checkResponse(response);
      } else {
        ApiChecker.checkApi(response, showToaster: showToaster);
        return response;
      }
    } catch (e) {
      Logger.e('ApiClient() => GET error: $e');
      return ApiChecker.handleError(e);
    }
  }

  Future<Response> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        bool handleError = false,
        bool showToaster = false,
      }) async {
    try {
      Logger.d('ApiClient() => POST request: $path, data: $data');
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      Logger.d('ApiClient() => POST handleError: $handleError response: ${response.data}');

      if (handleError) {
        return ApiChecker.checkResponse(response);
      } else {
        ApiChecker.checkApi(response, showToaster: showToaster);
        return response;
      }

    } catch (e) {
      Logger.e('ApiClient() => POST error: $e');
      return ApiChecker.handleError(e);
    }
  }

  Future<Response> postMultipartData(
      String path,
      Map<String, String> body,
      List<MultipartBody> multipartBody,
      List<MultipartDocument> otherFile, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        bool fromChat = false,
        bool handleError = false,
        bool showToaster = false,

      }) async {
    try {
      Logger.d('ApiClient() => POST Multipart request: $path');

      FormData formData = FormData();

      // Add text fields
      body.forEach((key, value) {
        formData.fields.add(MapEntry(key, value));
      });

      // Add images
      for (MultipartBody multipart in multipartBody) {
        if (multipart.file != null) {
          if (kIsWeb) {
            List<int> bytes = await multipart.file!.readAsBytes();
            formData.files.add(MapEntry(
              multipart.key,
              MultipartFile.fromBytes(
                bytes,
                filename: basename(multipart.file!.path),
                contentType: MediaType('image', 'jpg'),
              ),
            ));
          } else {
            File file = File(multipart.file!.path);
            formData.files.add(MapEntry(
              multipart.key,
              await MultipartFile.fromFile(
                file.path,
                filename: basename(file.path),
              ),
            ));
          }
        }
      }

      // Add documents
      if (otherFile.isNotEmpty) {
        for (MultipartDocument file in otherFile) {
          if (kIsWeb) {
            if (fromChat) {
              PlatformFile platformFile = file.file!.files.first;
              formData.files.add(MapEntry(
                'image[]',
                MultipartFile.fromBytes(
                  platformFile.bytes!,
                  filename: platformFile.name,
                ),
              ));
            } else {
              var fileBytes = file.file!.files.first.bytes!;
              formData.files.add(MapEntry(
                file.key,
                MultipartFile.fromBytes(
                  fileBytes,
                  filename: file.file!.files.first.name,
                ),
              ));
            }
          } else {
            File other = File(file.file!.files.single.path!);
            formData.files.add(MapEntry(
              file.key,
              await MultipartFile.fromFile(
                other.path,
                filename: basename(other.path),
              ),
            ));
          }
        }
      }

      final response = await _dio.post(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      Logger.d('ApiClient() => POST Multipart response: ${response.data}');
      // return ApiChecker.checkResponse(response);
      if (handleError) {
        return ApiChecker.checkResponse(response);
      } else {
        ApiChecker.checkApi(response, showToaster: showToaster);
        return response;
      }

    } catch (e) {
      Logger.e('ApiClient() => POST Multipart error: $e');
      return ApiChecker.handleError(e);
    }
  }

  Future<Response> put(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        bool handleError = false,
        bool showToaster = false,
      }) async {
    try {
      Logger.d('ApiClient() => PUT request: $path, data: $data');
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      Logger.d('ApiClient() => PUT response: ${response.data}');
      // return ApiChecker.checkResponse(response);
      if (handleError) {
        return ApiChecker.checkResponse(response);
      } else {
        ApiChecker.checkApi(response, showToaster: showToaster);
        return response;
      }
    } catch (e) {
      Logger.e('ApiClient() => PUT error: $e');
      return ApiChecker.handleError(e);
    }
  }

  Future<Response> delete(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        bool handleError = false,
        bool showToaster = false,
      }) async {
    try {
      Logger.d('ApiClient() => DELETE request: $path');
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      Logger.d('ApiClient() => DELETE response: ${response.data}');
      // return ApiChecker.checkResponse(response);
      if (handleError) {
        return ApiChecker.checkResponse(response);
      } else {
        ApiChecker.checkApi(response, showToaster: showToaster);
        return response;
      }
    } catch (e) {
      Logger.e('ApiClient() => DELETE error: $e');
      return ApiChecker.handleError(e);
    }
  }
}



