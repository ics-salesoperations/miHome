import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mihome_app/global/environment.dart';
import 'package:mihome_app/models/login_response.dart';
import 'package:mihome_app/services/usuario_service.dart';

class AuthService with ChangeNotifier {
  late String usuario;
  bool _autenticando = false;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  // Create storage
  final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  //Getters del token de forma estatica
  static Future<void> deleteToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'token_expiration');
  }

  Future<String> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token.toString();
  }

  Future<String> getTokenExp() async {
    const _storage = FlutterSecureStorage();
    final tokenExp = await _storage.read(key: 'token_expiration');
    return tokenExp ?? '662601600' //Timestamp 31-12-1990
        ;
  }

  Future<bool> login(String usuario, String password) async {
    final usuarioService = UsuarioService();
    autenticando = true;

    final osToken = await getTokenOS();
    final androidInfo = await deviceInfoPlugin.androidInfo;

    final data = {
      'usuario': usuario,
      'password': password,
      'appId': 500,
      'userId': osToken,
      'modelo': androidInfo.model,
    };

    try {
      final resp = await http
          .post(
            Uri.parse('${Environment.apiURL}/login'),
            body: jsonEncode(data),
            headers: {'Content-Type': 'application/json'},
            encoding: Encoding.getByName('utf-8'),
          )
          .timeout(
            const Duration(
              minutes: 2,
            ),
          );

      if (resp.statusCode == 200) {
        final loginResponse = loginResponseFromJson(
          resp.body,
        );
        this.usuario = loginResponse.usuario;

        await _guardarToken(
          loginResponse.token,
          loginResponse.exp,
        );
        await usuarioService.guardarUsuario();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(
      key: 'token',
    );

    final resp = await http
        .post(Uri.parse('${Environment.apiURL}/verificar_token'), headers: {
      'Content-Type': 'application/json',
      'token': token.toString() //header personalizado
    });

    if (resp.statusCode == 200) {
      return true;
    } else {
      this.logOut();
      return false;
    }
  }

  Future _guardarToken(String token, int exp) async {
    // Write value
    await _storage.write(key: 'token', value: token);
    await _storage.write(key: 'token_expiration', value: exp.toString());

    return;
  }

  Future guardarTokenOS(String token) async {
    const _storage = FlutterSecureStorage();
    // Write value
    await _storage.write(
      key: 'OSUserId',
      value: token,
    );

    return;
  }

  Future<String> getTokenOS() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'OSUserId');
    return token.toString();
  }

  Future logOut() async {
    // Delete value
    await _storage.delete(key: 'token_expiration');
    await _storage.delete(key: 'token');

    return;
  }
}
