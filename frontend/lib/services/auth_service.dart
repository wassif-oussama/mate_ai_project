import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Remplace par l'IP de ton PC si tu testes sur un vrai téléphone Android (ex: 192.168.1.X)
  // 10.0.2.2 est l'adresse magique pour l'émulateur Android vers localhost
  // 127.0.0.1 fonctionne pour Chrome ou l'application Windows locale
  static const String baseUrl = 'http://100.91.178.92:8000/api'; 
  // static const String baseUrl = 'http://127.0.0.1:8000/api';
  final storage = const FlutterSecureStorage();

  // 1. Inscription
  Future<bool> register(String username, String email, String password, String firstName, String lastName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print("Erreur d'inscription : $e");
      return false;
    }
  }

  // 2. Connexion
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // On sauvegarde le token d'accès dans le coffre-fort du téléphone
        await storage.write(key: 'jwt_token', value: data['access']);
        return true;
      }
      return false;
    } catch (e) {
      print("Erreur de connexion : $e");
      return false;
    }
  }

  // 3. Récupérer le Token pour les requêtes sécurisées
  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  // 4. Déconnexion
  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }
}