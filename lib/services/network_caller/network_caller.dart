import 'dart:convert';

import 'package:BabyCentric/features/common/data/models/error_response_model.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final dynamic responseData;
  final String? errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.errorMessage,
  });
}

class NetworkCaller {
  final Logger _logger = Logger();

  Future<NetworkResponse> getRequest(
    String url, {
    Map<String, dynamic>? queryParams,
    String? accessToken,
  }) async {
    try {
      Map<String, String> headers = {"content-type": "application/json"};
      if (accessToken != null) {
        headers["token"] = accessToken;
      }

      if (queryParams != null) {
        url += "?";
        for (String param in queryParams.keys) {
          url += "$param=${queryParams[param]}&";
        }
      }

      Uri uri = Uri.parse(url);
      _logRequest(url);
      Response response = await get(uri, headers: headers);

      _logResponse(
        url: url,
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );

      final decodedData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else {
        ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(
          decodedData,
        );
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: errorResponseModel.msg,
        );
      }
    } catch (e) {
      _logResponse(url: url, errorMessage: e.toString());
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> postRequest(
    String url, {
    String? accessToken,
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {"content-type": "application/json"};
      if (accessToken != null) {
        headers["token"] = accessToken;
      }

      _logRequest(url, headers, body);

      Response response = await post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      _logResponse(
        url: url,
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );

      final decodedData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else {
        ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(
          decodedData,
        );
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: errorResponseModel.msg,
        );
      }
    } catch (e) {
      _logResponse(url: url, errorMessage: e.toString());
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> deleteRequest(
    String url, {
    String? accessToken,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      Map<String, String> headers = {"content-type": "application/json"};
      if (accessToken != null) {
        headers["token"] = accessToken;
      }

      _logRequest(url, headers);

      Response response = await delete(uri, headers: headers);

      _logResponse(
        url: url,
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );

      final decodedData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else {
        ErrorResponseModel errorResponseModel = ErrorResponseModel.fromJson(
          decodedData,
        );
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: errorResponseModel.msg,
        );
      }
    } catch (e) {
      _logResponse(url: url, errorMessage: e.toString());
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  void _logRequest(
    String url, [
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  ]) {
    _logger.i("URL => $url\nHEADER => $headers\nBODY => $body");
  }

  void _logResponse({
    String? url,
    int? statusCode,
    Map<String, String>? headers,
    String? body,
    String? errorMessage,
  }) {
    if (errorMessage != null) {
      _logger.e("URL => $url \nError Message => $errorMessage");
    } else {
      _logger.i(
        "URL => $url \nStatusCode => $statusCode\nHEADER => $headers\nBODY => $body",
      );
    }
  }
}
