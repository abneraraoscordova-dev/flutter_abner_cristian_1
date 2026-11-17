import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String msgError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F2FF),
      appBar: AppBar(
        backgroundColor: Color(0xFF5E17EB),
        title: Row(
          children: [
            Icon(Icons.person, size: 15, color: Colors.white,),
            Text('Inciar Sesión', style: TextStyle(fontWeight: FontWeight.bold,),),
          ],
        )
      ),

      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8C52FF),
                  foregroundColor: Color(0xFFB892FF),
                ),
                child: Text('Iniciar Sesión con Google'),
                onPressed: () async{
                  try{
                    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

                    // Si el usuario cierra la ventanita sin elegir cuenta, no hace nada
                    if (googleUser == null) 
                    { return;}

                    //  Extraer los datos de la cuenta seleccionada
                    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
                     final OAuthCredential credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                  );
                  await FirebaseAuth.instance.signInWithCredential(credential); 
                    } catch(ex){
                      setState(() {
                        msgError = 'Hubo un Error al Intentar Iniciar Sesión';
                      });
                    }
                },
              ),

            const SizedBox(height: 15),
            // Texto rojo para mostrar errores
            Text(msgError, style: const TextStyle(color: Colors.red)),
          ],

        ),
      ),
    );
  }
} 


