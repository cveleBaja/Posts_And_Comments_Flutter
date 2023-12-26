import 'package:http/http.dart';

abstract class NetworkService {
  Future<Response> sendRequest(Uri uri);
}