
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:mime_type/mime_type.dart';


import 'package:validacionform/src/models/producto_model.dart';
import 'package:validacionform/src/share_prefs/preferencias_usuarios.dart';



///[]
class ProductoProvider {


  final String _url = 'https://flutter-varios-d87b9.firebaseio.com';
  final _prefs = new PreferenciasUsuario();


///[]
  Future<bool> crearProducto( ProductoModel producto ) async {
    final url = '$_url/producto.json?auth=${_prefs.token}';
    final resp = await http.post(url, body: productoModelToJson(producto));
    final decodeData = json.decode(resp.body);

    return true;
  }


///[]
  Future<bool> editarProducto( ProductoModel producto ) async {
    final url = '$_url/producto/${producto.id}.json?auth=${_prefs.token}';
    final resp = await http.put(url, body: productoModelToJson(producto));
    final decodeData = json.decode(resp.body);

    return true;
  }


///[]
  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/producto.json?auth=${_prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic> decodeData = json.decode(resp.body);
    final List<ProductoModel> productos = new List();

    if (decodeData == null) return [];

    decodeData.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;
      productos.add(prodTemp);
    });

    return productos;
  }


///[]
  Future<int> borrarProducto(String id) async {
    final url = '$_url/producto/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);

    return 1;
  }


///[]
  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/devexb0a6/image/upload?upload_preset=k4l4izi2');
    final mineType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file',
      imagen.path,
      contentType: MediaType(mineType[0], mineType[1])
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);

    return respData['secure_url'];
  }

}