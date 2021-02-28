
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import 'package:validacionform/src/models/producto_model.dart';
import 'package:validacionform/src/providers/productos_provider.dart';
import 'package:validacionform/src/utils/utils.dart' as utils;

///[]
class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}


///[]
class _ProductoPageState extends State<ProductoPage> {

///[formKey] para controlar el Form
  final formKey     = GlobalKey<FormState>();
  final scaffotdKey = GlobalKey<ScaffoldState>();
  final productosProvider = new ProductoProvider();

///[]
  ProductoModel producto = new ProductoModel();

  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      producto = prodData;
    }

    return Scaffold(
      key: scaffotdKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton()
              ],
            ),
          ),
        ),
      ),
    );
  }

///[]
  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value.length < 3)
          return 'Ingrese el nombre del producto';
        else
          return null;
      },
    );
  }

///[]
  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value) {
        if ( utils.isNumeric(value) )
          return null;
        else
          return 'Solo numeros';
      },
    );
  }

///[]
  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
    );
  }

///[]
  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) {
        setState(() {
          producto.disponible = value;
        });
      },
    );
  }

///[]
  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() { _guardando = true; });

    if (foto != null) {
      producto.fotoUrl = await productosProvider.subirImagen(foto);
    }


    if (producto.id == null) {
      productosProvider.crearProducto(producto);
    } else {
      productosProvider.editarProducto(producto);
    }


    setState(() { _guardando = false; });

    mostrarSnackbar('Registro guardado');

    // Navigator.pop(context);
    Navigator.popAndPushNamed(context, 'home');
  }


///[]
  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(seconds: 2),
    );

    scaffotdKey.currentState.showSnackBar(snackbar);
  }


///[]
  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
          image: NetworkImage(producto.fotoUrl),
          placeholder: AssetImage('assets/jar-loading.gif'),
          height: 300.0,
          width: double.infinity,
          fit: BoxFit.contain,
      );
    } else {
      return Image(
        image: foto != null ? FileImage(foto) : AssetImage('assets/no-image.png'),
        // image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

///[]
  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery); 
  }

///[]
  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

///[]
  _procesarImagen(ImageSource origen) async {
    foto = await ImagePicker.pickImage(
      source: origen
    );

    if (foto != null) {
      producto.fotoUrl = null;
    } else {}

    setState(() { });
  }


}