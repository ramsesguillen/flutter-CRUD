
import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:validacionform/src/share_prefs/preferencias_usuarios.dart';




class UsuarioProvider {

///[]
  final String _fireBaseTpken = '';
  final _prefs = new PreferenciasUsuario();


///[]
  Future<Map<String, dynamic>> login(String email, String password) async {
    final authDAta = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_fireBaseTpken',
      body: json.encode(authDAta)
    );


    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return { 'ok': true, 'token': decodedResp['idToken']};
    } else {
      return { 'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }


///[]
  Future<Map<String, dynamic>> nuevoUsuario(String email, String password) async {
    final authDAta = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_fireBaseTpken',
      body: json.encode(authDAta)
    );


    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return { 'ok': true, 'token': decodedResp['idToken']};
    } else {
      return { 'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }



}