import 'dart:convert';
import 'package:http/http.dart' as http;

/// Small typed wrapper around Convex's public HTTP query/mutation endpoints.
/// Requires the deployment URL and a valid user JWT. Never use an admin key here.
class ConvexHttpClient {
  ConvexHttpClient({required this.deploymentUrl, required this.accessToken, http.Client? client})
      : _client = client ?? http.Client();

  final String deploymentUrl;
  final String accessToken;
  final http.Client _client;

  Uri _endpoint(String endpoint) {
    final base = deploymentUrl.replaceFirst(RegExp(r'/+$'), '');
    return Uri.parse('$base/api/$endpoint');
  }

  Future<dynamic> query(String functionPath, [Map<String, dynamic> args = const {}]) =>
      _call('query', functionPath, args);

  Future<dynamic> mutation(String functionPath, [Map<String, dynamic> args = const {}]) =>
      _call('mutation', functionPath, args);

  Future<dynamic> _call(String kind, String functionPath, Map<String, dynamic> args) async {
    if (!deploymentUrl.startsWith('https://') || !deploymentUrl.contains('.convex.cloud')) {
      throw const ConvexClientException('Convex URL is not configured.');
    }
    if (accessToken.trim().isEmpty) {
      throw const ConvexClientException('Sign in is required before accessing Liquid POS data.');
    }
    final response = await _client.post(
      _endpoint(kind),
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({'path': functionPath, 'args': args, 'format': 'json'}),
    );
    dynamic body;
    try { body = jsonDecode(response.body); } catch (_) {
      throw ConvexClientException('Convex returned an unreadable response (HTTP ${response.statusCode}).');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ConvexClientException(_errorMessage(body, response.statusCode));
    }
    if (body is Map && body['status'] == 'success') return body['value'];
    if (body is Map && body['status'] == 'error') {
      throw ConvexClientException(body['errorMessage']?.toString() ?? 'Convex request failed.');
    }
    throw const ConvexClientException('Unexpected response from Convex.');
  }

  String _errorMessage(dynamic body, int status) {
    if (body is Map) return body['errorMessage']?.toString() ?? 'Convex request failed (HTTP $status).';
    return 'Convex request failed (HTTP $status).';
  }

  void close() => _client.close();
}

class ConvexClientException implements Exception {
  const ConvexClientException(this.message);
  final String message;
  @override
  String toString() => message;
}
