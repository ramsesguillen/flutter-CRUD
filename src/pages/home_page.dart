import 'package:flutter/material.dart';
import 'package:validacionform/src/bloc/provider.dart';
import 'package:validacionform/src/models/producto_model.dart';
import 'package:validacionform/src/providers/productos_provider.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productoProvider = new ProductoProvider();

  @override 
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        centerTitle: true,
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto'),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: productoProvider.cargarProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {

        if (snapshot.hasData){
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) => _crearItem(context, productos[index]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductoModel producto) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) {
        productoProvider.borrarProducto(producto.id)
          .then((value) {
            setState(() {});
          }
        );
      },
      child: Card(
        child: Column(
          children: [
            (producto.fotoUrl == null )
            ? Image(image: AssetImage('assets/no-image.png'))
            : FadeInImage(
                image: NetworkImage(producto.fotoUrl),
                placeholder: AssetImage('assets/jar-loading.gif'),
                height: 300.0,
                width: double.infinity,
                fit: BoxFit.cover,
            ),
          ListTile(
            title: Text('${producto.titulo} - ${producto.valor}'),
            subtitle: Text(producto.id),
            onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
          )
          ],
        ),
      ),
    );
  }
}