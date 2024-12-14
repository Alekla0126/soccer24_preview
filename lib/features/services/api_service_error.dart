import '../../constants/strings.dart';
import 'package:dio/dio.dart';


class ApiServiceError implements Exception {
  final String message;

  const ApiServiceError([this.message = Strings.somethingWentWrong]);

  factory ApiServiceError.fromCode(int? code) {
    switch (code) {
      case 401:
        return const ApiServiceError(Strings.apiDefaultErrorMsg);
      case 404:
        return const ApiServiceError(Strings.apiResourceNotFound);
      default:
        return const ApiServiceError();
    }
  }

  factory ApiServiceError.fromType(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
        return const ApiServiceError(Strings.apiTimeout);
      case DioExceptionType.connectionError:
        return const ApiServiceError(Strings.apiDefaultErrorMsg);
      case DioExceptionType.receiveTimeout:
        return const ApiServiceError(Strings.apiReceiveTimeout);
      case DioExceptionType.badResponse:
        return const ApiServiceError(Strings.apiBadResponse);
      case DioExceptionType.cancel:
        return const ApiServiceError(Strings.apiRequestCanceled);
      default:
        return const ApiServiceError();
    }
  }
}