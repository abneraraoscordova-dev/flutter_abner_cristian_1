import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'principal.dart';

//Este archivo escucha al firebase y elige si mandar al susuaroio al home o al login

class AuthWrapper extends StatelessWidget{
  const AuthWrapper({super.key});
   @override
  Widget build(BuildContext context) {
   return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot){
      if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Si hay un usuario conectado, lo manda al Home
        if (snapshot.hasData) {
          return const HomePage();
        }

        if (snapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text('Ocurrió un Error al intentar iniciar Sesión'),
              ),
            );
        }
        // Si no hay nadie conectado, lo manda al Login
        return const LoginPage();

    }

   );
  }




}