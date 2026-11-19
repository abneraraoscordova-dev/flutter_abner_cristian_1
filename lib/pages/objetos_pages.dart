import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                separatorBuilder: (context, index) => const Divider(),

                itemBuilder: (context, index){
                  final data = docs[index].data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data['titulo']?? 'Sin titulo'),
                  );
                },
              );


        }
      );
    
  }
}