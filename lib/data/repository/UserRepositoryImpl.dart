import 'dart:convert';
import 'package:post_and_comments/utils/Constants.dart';
import 'package:post_and_comments/domain/network/NetworkService.dart';
import 'package:post_and_comments/domain/model/User.dart';
import 'package:post_and_comments/domain/repository/UserRepository.dart';

class UserRepositoryImpl implements UserRepository {

  final NetworkService _networkService;

  UserRepositoryImpl({required NetworkService networkService}) : _networkService = networkService;

  Future<int?> getUserIdByUsername(String username) async {
    final response = await _networkService.sendRequest(Uri.parse('${Constants.BASE_URL}/users?username=$username'));
    if (response.statusCode >= 200 || response.statusCode <= 299) {
      final parsed = (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
      final users = parsed.map<User>((json) => User.fromJson(json)).toList();

      if (users.isNotEmpty) {
        return users.first.id;
      }

      return null;
    }

    throw Exception('Failed to fetch users');
  }
}