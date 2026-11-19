import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abner_cristian_1/app_colors.dart';
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
      backgroundColor: AppColors.cfondo,
      appBar: AppBar(
        backgroundColor: AppColors.cappbar,
        title: Row(
          children: [
            Icon(Icons.person, size: 30, color: Colors.white, ),
            Text('     '),
            Text('Inciar Sesión', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
          ],
        )
      ),

      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cbotones,
                  foregroundColor: AppColors.cbordes,
                ),
                child: Text('Iniciar Sesión con Google', ),
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


