
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_abner_cristian_1/app_colors.dart';
import '../services/firestore_service.dart';


class MispublicacionesPage extends StatefulWidget {
  const MispublicacionesPage({super.key});

  @override
  State<MispublicacionesPage> createState() => _MispublicacionesPageState();
}

class _MispublicacionesPageState extends State<MispublicacionesPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreService().misPublicaciones(),
      builder: ((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return  Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty){
          return Center(child: Text('Al parecer No Has perdido ni encontrado nada '));
        }

        final docs = snapshot.data!.docs;

        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final docId = docs[index].id;
            final data = docs[index].data() as Map <String, dynamic>;
            final String titulo = data['titulo'] ?? 'sin titulo';
            final String tipo = data['tipo'] ?? 'sin tipo';
            final String categoria = data['categoria'] ?? 'sin categoria';
            final String estado = data['estado'] ?? 'Vigente';
            final String? foto = data['foto'];
            final bool devuelto = estado.toLowerCase() == 'devuelto';
           

            return ListTile(
              tileColor: devuelto? Colors.green.shade100: null,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: (foto != null && foto.isNotEmpty)
                    ? Image.memory(
                        base64Decode(foto),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        color: AppColors.tarjetas,
                        child: const Icon(Icons.desktop_access_disabled),
                      ),
              ),
              title: Text(
                titulo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Fue $tipo $categoria'),
               trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      color: devuelto ? Colors.green : Colors.red.shade200,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      estado,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_square, size: 22),
                    onPressed: () async {
                      final nuevoEstado = devuelto ? 'Vigente' : 'Devuelto';
                      await FirestoreService().cambiarEstado(docId, nuevoEstado);
                    },
                  ),
                ],
               ),


            );
          },
        );

      })
    );
  }
}