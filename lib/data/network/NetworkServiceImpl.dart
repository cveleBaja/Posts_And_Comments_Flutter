import 'package:post_and_comments/domain/network/NetworkService.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class NetworkServiceImpl implements NetworkService {

  @override
  Future<Response> sendRequest(Uri uri) {
    return http.get(uri);
  }
}