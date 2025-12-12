import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';
import '../services/auth_service.dart';

class ApiService {
  static const String baseUrl = 'https://api.adhyan.guru';
  final AuthService _authService = AuthService();

  // Helper method to get headers with auth token
  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (includeAuth) {
      final token = await _authService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Helper method to handle API responses
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final body = response.body;
        if (body.isEmpty) {
          return {};
        }
        
        // Try to decode JSON
        final decoded = json.decode(body);
        
        // If decoded is a Map, return it
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        
        // If decoded is a String, wrap it
        if (decoded is String) {
          return {'message': decoded};
        }
        
        // If decoded is a List, wrap it
        if (decoded is List) {
          return {'data': decoded};
        }
        
        return {};
      } else {
        final body = response.body;
        if (body.isEmpty) {
          throw ApiException(
            message: 'An error occurred (${response.statusCode})',
            statusCode: response.statusCode,
          );
        }
        
        try {
          final errorBody = json.decode(body);
          if (errorBody is Map<String, dynamic>) {
            throw ApiException(
              message: errorBody['message']?.toString() ?? 'An error occurred',
              statusCode: response.statusCode,
            );
          } else if (errorBody is String) {
            throw ApiException(
              message: errorBody,
              statusCode: response.statusCode,
            );
          }
        } catch (e) {
          if (e is ApiException) {
            rethrow;
          }
          throw ApiException(
            message: body,
            statusCode: response.statusCode,
          );
        }
        
        throw ApiException(
          message: 'An error occurred',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Failed to parse response: ${e.toString()}',
        statusCode: response.statusCode,
      );
    }
  }

  // Authentication APIs
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/agents/login'),
        headers: await _getHeaders(includeAuth: false),
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final data = _handleResponse(response);
      if (data is Map<String, dynamic>) {
        final loginResponse = LoginResponse.fromJson(data);
        
        // Store token
        if (loginResponse.data?.token != null) {
          await _authService.saveToken(loginResponse.data!.token!);
          await _authService.saveUser(loginResponse.data!);
        }

        return loginResponse;
      } else {
        throw ApiException(message: 'Invalid login response format');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  Future<ApiResponse> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/agents/logout'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      await _authService.clearAuth();
      if (data is Map<String, dynamic>) {
        return ApiResponse.fromJson(data);
      } else {
        return ApiResponse(success: true, message: 'Logged out');
      }
    } catch (e) {
      // Even if logout fails, clear local auth
      await _authService.clearAuth();
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  // Profile APIs
  Future<AgentProfile> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/agents/profile'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      if (data['data'] != null && data['data'] is Map<String, dynamic>) {
        return AgentProfile.fromJson(data['data'] as Map<String, dynamic>);
      } else if (data is Map<String, dynamic> && data.containsKey('_id')) {
        // If data is the profile itself
        return AgentProfile.fromJson(data);
      } else {
        throw ApiException(message: 'Invalid profile data format');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  Future<AgentCodeResponse> getMyCode() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/agents/my-code'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      if (data is Map<String, dynamic>) {
        return AgentCodeResponse.fromJson(data);
      } else {
        throw ApiException(message: 'Invalid agent code response format');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  // Dashboard APIs
  Future<WalletBalance> getWalletBalance() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/agents/wallet-balance'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      if (data['data'] != null && data['data'] is Map<String, dynamic>) {
        return WalletBalance.fromJson(data['data'] as Map<String, dynamic>);
      } else if (data.containsKey('balance')) {
        // If data is the wallet balance itself
        return WalletBalance.fromJson(data);
      } else {
        throw ApiException(message: 'Invalid wallet balance data format');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  Future<StudentsResponse> getMyStudents({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/agents/students?page=$page&limit=$limit'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      if (data is Map<String, dynamic>) {
        return StudentsResponse.fromJson(data);
      } else {
        throw ApiException(message: 'Invalid students response format');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  Future<CommissionsResponse> getMyCommissions({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      String url = '$baseUrl/api/agents/commissions?page=$page&limit=$limit';
      if (status != null) {
        url += '&status=$status';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      if (data is Map<String, dynamic>) {
        return CommissionsResponse.fromJson(data);
      } else {
        throw ApiException(message: 'Invalid commissions response format');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  Future<StudentSignupAnalytics> getStudentSignupAnalytics({
    bool includeSubagents = false,
    int? month,
    int? year,
    String? startDate,
    String? endDate,
  }) async {
    try {
      String url = '$baseUrl/api/agent/analytics/student-signups?includeSubagents=$includeSubagents';
      if (month != null) url += '&month=$month';
      if (year != null) url += '&year=$year';
      if (startDate != null) url += '&startDate=$startDate';
      if (endDate != null) url += '&endDate=$endDate';

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      if (data['data'] != null && data['data'] is Map<String, dynamic>) {
        return StudentSignupAnalytics.fromJson(data['data'] as Map<String, dynamic>);
      } else if (data.containsKey('agent')) {
        // If data is the analytics itself
        return StudentSignupAnalytics.fromJson(data);
      } else {
        throw ApiException(message: 'Invalid analytics data format');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  Future<DetailedStudentSignupsResponse> getDetailedStudentSignups({
    bool includeSubagents = false,
    int? month,
    int? year,
    String? startDate,
    String? endDate,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      String url = '$baseUrl/api/agent/analytics/student-signups/detailed?includeSubagents=$includeSubagents&page=$page&limit=$limit';
      if (month != null) url += '&month=$month';
      if (year != null) url += '&year=$year';
      if (startDate != null) url += '&startDate=$startDate';
      if (endDate != null) url += '&endDate=$endDate';

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      if (data is Map<String, dynamic>) {
        return DetailedStudentSignupsResponse.fromJson(data);
      } else {
        throw ApiException(message: 'Invalid detailed signups response format');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  // Wallet Management APIs
  Future<WalletDetails> getWalletDetails() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/agent/wallet'),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      if (data['data'] != null && data['data'] is Map<String, dynamic>) {
        return WalletDetails.fromJson(data['data'] as Map<String, dynamic>);
      } else if (data.containsKey('balance')) {
        // If data is the wallet details itself
        return WalletDetails.fromJson(data);
      } else {
        throw ApiException(message: 'Invalid wallet details data format');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }

  Future<WalletTransactionsResponse> getWalletTransactions({
    int page = 1,
    int limit = 20,
    String? type,
    String? from,
    String? to,
  }) async {
    try {
      String url = '$baseUrl/api/agent/wallet/transactions?page=$page&limit=$limit';
      if (type != null) url += '&type=$type';
      if (from != null) url += '&from=$from';
      if (to != null) url += '&to=$to';

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      if (data is Map<String, dynamic>) {
        return WalletTransactionsResponse.fromJson(data);
      } else {
        throw ApiException(message: 'Invalid transactions response format');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: e.toString());
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

