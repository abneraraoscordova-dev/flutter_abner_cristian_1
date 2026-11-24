// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abner_cristian_1/app_colors.dart';
import 'package:flutter_abner_cristian_1/pages/misPublicaciones_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../pages/perfil_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/objetos_pages.dart';
class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  int indice = 0;


  List<IconData> iconosTitulos = [
    Icons.person,
    Icons.view_list_outlined,
    Icons.search,
  ];

  List<String> titulos = [
    FirebaseAuth.instance.currentUser?.displayName ?? 'Mi perfil',
    'Objetos Perdidos',
    'Mis Objetos',

  ];

  final List <Widget> paginas = [
    const PerfilPages(),
    const ObjetosPages(),
    const MispublicacionesPage(),
    
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        actions: [
        IconButton(
         icon: const Icon(Icons.logout),
         color: Colors.white,
         iconSize: 30,
        onPressed: () async {
        await GoogleSignIn().signOut();
        await FirebaseAuth.instance.signOut();
        
        
        }
       
        ),
      ],

        title: Row(
          
          children: [
            Icon(iconosTitulos[indice], color: Colors.white, size: 30,),
            SizedBox(width: 12),
            Text(titulos[indice], style: TextStyle(color: Colors.white, fontSize: 20,) ,),
          ],
        ),
        backgroundColor: AppColors.cappbar,
        foregroundColor: AppColors.cbordes,
      ),
    
  
      body: Row(
        children: [
        
          Expanded(
            child: Center(
              child: paginas[indice],
            ),
          ),
        


    const VerticalDivider(thickness: 1, width: 2),
    NavigationRail(
      selectedIndex: indice,
      groupAlignment: 0.0,
      onDestinationSelected: (int Index){
        setState(() {
          indice = Index;
        });
      },

      backgroundColor: AppColors.cfondo,
      indicatorColor: AppColors.cIndicador,
      labelType: NavigationRailLabelType.all,

      destinations: const[
        
        
         NavigationRailDestination(
           padding: EdgeInsets.symmetric(vertical: 40),
            icon: Icon(Icons.person, color: AppColors.textoSecundario),
            selectedIcon: Icon(Icons.person, color:AppColors.cbotones,),
            label: Text('Yo'),

           ),
           NavigationRailDestination(
            padding: EdgeInsets.symmetric(vertical: 40),
            icon: Icon(Icons.format_list_bulleted, color:   AppColors.textoSecundario),
            selectedIcon: Icon(Icons.format_list_bulleted, color:AppColors.cbotones,),
            label: Text('Objetos'),
           ),
           NavigationRailDestination(
            padding: EdgeInsets.symmetric(vertical: 40),
            icon: Icon(Icons.insert_comment_rounded, color:AppColors.textoSecundario),
            selectedIcon: Icon(Icons.insert_comment_rounded, color:AppColors.cbotones,),
            label: Text('Mis Objetos'),
            ),

      ],
    )
]
      ),
    );
  }
}