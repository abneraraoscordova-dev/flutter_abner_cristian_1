import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_abner_cristian_1/app_colors.dart';
import 'package:flutter_abner_cristian_1/pages/detalle_page.dart';
import '../services/firestore_service.dart';

class ObjetosPages extends StatefulWidget {
  const ObjetosPages({super.key});

  @override
  State<ObjetosPages> createState() => _ObjetosPagesState();
}

class _ObjetosPagesState extends State<ObjetosPages> {
  @override
  Widget build(BuildContext context) {
   
      return StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().obtenerPublicaciones(),
        builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                 return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty){
                return const Center(child: Text('No hay objetos publicados aún.'));
              }
              final docs = snapshot.data!.docs;


              return ListView.separated(
                 itemCount: docs.length,
                separatorBuilder: (context, index) => const Divider(height: 1),

                itemBuilder: (context, index){
                  final data = docs[index].data() as Map<String, dynamic>;  

                  final String titulo = data['titulo'] ?? 'sin título';
                  final String tipo = data['tipo'] ?? 'sin tipo';
                  final String categoria = data['categoria'] ?? 'sin categoria';
                  final String estado = data['estado'] ?? 'Vigente';
                  final String? foto = data['foto'];
                  final bool devuelto = estado.toLowerCase() == 'devuelto';

                  return ListTile(
                    tileColor: devuelto ? Colors.green.shade100 : null,
                    //fotito
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: (foto != null && foto.isNotEmpty)
                      ? Image.memory(
                        base64Decode(foto),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,   
                      ): Container(    
                        width: 50,
                        height: 50,
                        color: AppColors.tarjetas,
                        child: Icon(Icons.desktop_access_disabled),
                      )
                    ),
                    title: Text(titulo ,style: TextStyle(fontWeight: FontWeight.bold,)),
                    subtitle:Text('Fue $tipo  $categoria', ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: devuelto ? Colors.green : Colors.red.shade200,
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Text(
                            estado,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white
                            ),
                          ),
                        ),
                        
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 18),   
                          onPressed: (){
                            Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => DetallePage(data: data)),
                            );
                            
                          }
                        )
                      ],
                    ), 
                      
                   
                  );
                },
              );


        }
      );
    
  }
}