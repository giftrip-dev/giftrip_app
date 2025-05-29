import 'package:dio/dio.dart';
import 'package:giftrip/core/app.dart';
import 'package:giftrip/core/services/storage_service.dart';
import 'package:giftrip/core/storage/auth_storage.dart';
import 'package:giftrip/core/utils/env_config.dart';
import 'package:giftrip/core/utils/logger.dart';
import 'package:giftrip/features/auth/repositories/auth_repo.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late final Dio _dio;
  final AuthStorage _authStorage = AuthStorage();
  final GlobalStorage _globalStorage = GlobalStorage();

  // 토큰 필요 없는 요청 경로
  static const List<String> _pathsWithoutToken = [
    "/login",
    "/api/auth/social-login",
  ];

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.fullApiUrl,
        connectTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 10000),
        sendTimeout: const Duration(milliseconds: 10000),
      ),
    );

    _addInterceptors();
  }

  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  Future<void> _onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    logger.d('Request: ${options.method} ${options.path}');

    if (options.path.contains("/auth/rotate-tokens")) {
      options.headers.remove('Authorization');
    } else if (!_pathsWithoutToken.any((path) => options.path.contains(path))) {
      String? accessToken = await _authStorage.getAccessToken();
      if (accessToken != null) {
        logger.d('Access Token: $accessToken');
        options.headers['Authorization'] = "Bearer $accessToken";
      }
    }

    handler.next(options);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    logger
        .d('Response: ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  Future<void> _onError(
      DioException err, ErrorInterceptorHandler handler) async {
    logger.e('Error: ${err.message}');
    logger.e('Error StatusCode: ${err.response?.statusCode}');
    logger.e('Error RequestPath: ${err.requestOptions.path}');

    final statusCode = err.response?.statusCode;
    final requestPath = err.requestOptions.path;
    final errorMessage = err.response?.data is Map<String, dynamic>
        ? err.response?.data['message'] as String? ??
            err.response?.data['error'] as String?
        : null;

    // 만료된 토큰일 경우
    if (statusCode == 401 || errorMessage == 'token-expired') {
      if (requestPath.contains('/auth/rotate-tokens')) {
        _handleRefreshFail();
        return handler.reject(err);
      }

      if (requestPath.contains('/login')) {
        return handler.next(err);
      }

      try {
        final retryResponse = await _handleTokenRefresh(err);
        return handler.resolve(retryResponse);
      } catch (_) {
        _handleRefreshFail();
        return handler.reject(err);
      }
    }

    if (statusCode == 599 && requestPath.contains('/auth/rotate-tokens')) {
      logger.d('599 Error on /auth/rotate-tokens: ${requestPath}');
      _handleRefreshFail();
      return handler.reject(err);
    }

    if (statusCode == 409) {
      logger.d('409 Error on /auth/send-code: ${requestPath}');
      return handler.reject(err);
    }

    return handler.next(err);
  }

  Future<Response> _handleTokenRefresh(DioException err) async {
    logger.d('Try refreshToken: ${err.requestOptions.path}');

    await AuthRepository().refreshAccessToken();

    final newAccessToken = await _authStorage.getAccessToken();
    logger.d('New Access Token: $newAccessToken');

    final options = err.requestOptions;
    options.headers['Authorization'] = "Bearer $newAccessToken";

    if (options.data is FormData) {
      FormData formData = FormData();
      formData.fields.addAll(options.data.fields);
      options.data = formData;
    }

    return await _dio.request(
      options.path,
      options: Options(
        method: options.method,
        headers: options.headers,
        contentType: options.contentType,
      ),
      data: options.data,
      queryParameters: options.queryParameters,
    );
  }

  void _handleRefreshFail() {
    _authStorage.deleteLoginToken();
    _authStorage.deleteUserInfo();
    _authStorage.removeAutoLogin();

    // 로그인 페이지로 이동
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil('/login', (route) => false);
    logger.e('토큰 만료');
  }

  Dio to() {
    return _dio;
  }
}
