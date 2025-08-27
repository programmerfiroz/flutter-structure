import 'package:dio/dio.dart';
import 'package:hash_code/core/services/storage/token_manger.dart';
import 'package:get/get.dart' as getx;
import '../../../routes/route_helper.dart';
import '../../constants/app_constants.dart';
import '../../utils/custom_snackbar.dart';
import '../../utils/logger.dart';
import '../storage/shared_prefs.dart';
import 'error_handler.dart';

class ApiChecker {
  static Response checkResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        if (response.data['res'] == 'success') {
          return response;
        }
        else {
          _showErrorMessage(response);
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: response.data['msg'] ?? 'Something went wrong',
          );
        }
      case 401:
        _showErrorMessage(response, 'Unauthorized');
        _logout();
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Unauthorized',
        );
      case 403:
        _showErrorMessage(response, 'Forbidden');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Forbidden',
        );
      case 404:
        _showErrorMessage(response, 'Not Found');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Not Found',
        );
      case 422:
        _showValidationErrors(response);
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Validation Error',
        );
      case 500:
        _showErrorMessage(response, 'Server Error');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Server Error',
        );
      default:
        _showErrorMessage(response);
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Something went wrong',
        );
    }
  }

  static Response handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          CustomSnackbar.showError('Connection timeout');
          break;
        case DioExceptionType.sendTimeout:
          CustomSnackbar.showError('Send timeout');
          break;
        case DioExceptionType.receiveTimeout:
          CustomSnackbar.showError('Receive timeout');
          break;
        case DioExceptionType.badCertificate:
          CustomSnackbar.showError('Bad certificate');
          break;
        case DioExceptionType.badResponse:
        // Handle structured API errors here
          if (error.response?.data != null) {
            try {
              // Use the ErrorResponse class to parse errors
              ErrorResponse errorResponse = ErrorResponse.fromJson(error.response!.data);
              if (errorResponse.errors != null && errorResponse.errors!.isNotEmpty) {
                CustomSnackbar.showError(errorResponse.errors!.first.message ?? 'Unknown error');
              } else {
                CustomSnackbar.showError('Something went wrong');
              }
            } catch (e) {
              CustomSnackbar.showError('Something went wrong');
            }
          } else {
            CustomSnackbar.showError('Bad response');
          }
          break;
        case DioExceptionType.cancel:
          CustomSnackbar.showError('Request cancelled');
          break;
        case DioExceptionType.connectionError:
          CustomSnackbar.showError('No internet connection');
          break;
        case DioExceptionType.unknown:
          CustomSnackbar.showError('Something went wrong');
          break;
      }

      Logger.e('DioError: ${error.message}');

      return Response(
        requestOptions: error.requestOptions,
        statusCode: error.response?.statusCode ?? 500,
        data: error.response?.data ?? {'res': 'error', 'msg': 'Something went wrong'},
      );
    } else {
      Logger.e('Error: $error');
      CustomSnackbar.showError('Something went wrong');

      return Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
        data: {'res': 'error', 'msg': 'Something went wrong'},
      );
    }
  }

  static void _showErrorMessage(Response response, [String? defaultMessage]) {
    final message = response.data['msg'] +"${response.statusCode}" ?? defaultMessage ?? 'Something went wrong';
    CustomSnackbar.showError(message);
  }

  static void _showValidationErrors(Response response) {
    if (response.data != null) {
      try {
        // Parse validation errors using ErrorResponse class
        ErrorResponse errorResponse = ErrorResponse.fromJson(response.data);
        if (errorResponse.errors != null && errorResponse.errors!.isNotEmpty) {
          // Display the first error message
          CustomSnackbar.showError(errorResponse.errors!.first.message ?? 'Validation Error');
        } else {
          CustomSnackbar.showError('Validation Error');
        }
      } catch (e) {
        // Fallback for when response data doesn't match expected format
        if (response.data['msg'] != null) {
          CustomSnackbar.showError(response.data['msg']);
        } else {
          CustomSnackbar.showError('Validation Error');
        }
      }
    } else {
      CustomSnackbar.showError('Validation Error');
    }
  }


  static void _logout() {
    SharedPrefs.remove(AppConstants.userData);
    SharedPrefs.setBool(AppConstants.isLoggedIn, false);
    TokenManager.clearToken();
    getx.Get.offAllNamed(RouteHelper.getLoginRoute());
  }

  // Add a static method to check API responses without throwing exceptions
  static void checkApi(Response response, {bool showToaster = false}) {
    if (response.statusCode != 200) {
      if (response.data != null) {
        try {
          // Try to parse as structured error
          ErrorResponse errorResponse = ErrorResponse.fromJson(response.data);
          if (errorResponse.errors != null && errorResponse.errors!.isNotEmpty) {
            String? errorMessage = errorResponse.errors!.first.message;
            if (showToaster && errorMessage != null) {
              CustomSnackbar.showError(errorMessage);
            }
          }
        } catch (e) {
          // Not a structured error, try simple message
          if (response.data['msg'] != null) {
            if (showToaster) {
              CustomSnackbar.showError(response.data['msg']);
            }
          } else {
            if (showToaster) {
              CustomSnackbar.showError('Something went wrong');
            }
          }
        }
      } else {
        if (showToaster) {
          CustomSnackbar.showError('Something went wrong');
        }
      }
    }
  }


}
