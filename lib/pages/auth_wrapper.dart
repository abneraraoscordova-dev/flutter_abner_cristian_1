import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'principal.dart';



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
        
        return const LoginPage();

    }

   );
  }

}