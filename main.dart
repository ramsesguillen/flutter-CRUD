import 'package:flutter/material.dart';
//
import 'package:validacionform/src/bloc/provider.dart';
import 'package:validacionform/src/pages/home_page.dart';
import 'package:validacionform/src/pages/login_page.dart';
import 'package:validacionform/src/pages/producto_page.dart';
import 'package:validacionform/src/pages/registro_page.dart';
import 'package:validacionform/src/share_prefs/preferencias_usuarios.dart';
 
// void main() => runApp(MyApp());
void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    print(prefs.token);
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login'   : (BuildContext contex) => LoginPage(),
          'registro'   : (BuildContext contex) => ReguistroPage(),
          'home'    : (BuildContext contex) => HomePage(),
          'producto'    : (BuildContext contex) => ProductoPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      ),
    );
  }
}