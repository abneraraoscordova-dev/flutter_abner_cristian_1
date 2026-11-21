import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetallePage extends StatelessWidget {
  final Map<String, dynamic> data;
  const DetallePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String titulo = data['titulo'] ?? 'Sin título';
    final String tipo = data['tipo'] ?? 'Sin tipo';
    final String categoria = data['categoria'] ?? 'Sin categoría';
    final String estado = data['estado'] ?? 'Vigente';
    final String descripcion = data['descripcion'] ?? 'Sin descripción';
    final String lugar = data['lugar'] ?? 'No especificado';
    final String autor = data['autorNombre']  ?? 'Anónimo';
    final String contacto = data['autorCorreo'] ?? 'Sin Contacto';
    final String? foto = data['foto'];
    final bool devuelto = estado.toLowerCase() == 'devuelto';
    

    String fechaFinal = 'Sin fecha';
    if (data['fechaCreacion'] is Timestamp){
      final DateTime fecha = (data['fechaCreacion'] as Timestamp).toDate();
      fechaFinal = '$fecha';
    }

    return Scaffold(
      backgroundColor: devuelto? Colors.green.shade200 : Colors.red.shade200,
      appBar: AppBar(
        title: Text('Detalle de objeto  ',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: devuelto ? Colors.green.shade200 : Colors.red.shade200
      ),
      body: SingleChildScrollView(
        
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (foto != null && foto.isNotEmpty)
              Image.memory(
                base64Decode(foto),
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else Text('sin foto'),
            const SizedBox(height: 16),

            Row(
              children: [
                Text('Nombre del Objeto: ', style: TextStyle(fontWeight: FontWeight.bold,)),
                Text('$titulo')
              ],
            ),
           
            
            Row(
              children: [
                Text('Estado: ', style: TextStyle(fontWeight: FontWeight.bold,)),
                Text('$estado')
              ],
            ),
            const SizedBox(height: 8),
            Text('Tipo: $tipo'),
            const SizedBox(height: 8),
            Text('Categoría: $categoria'),
            const SizedBox(height: 8),
            Text('Descripción: $descripcion'),
            const SizedBox(height: 8),
            Text('Lugar: $lugar'),
            const SizedBox(height: 8),
            Text('Autor: $autor'),
            const SizedBox(height: 8),
            Text('Contacto: $contacto'),
            const SizedBox(height: 8),
            Text('Fecha: $fechaFinal'),
            
            
           
          ],
        ),
      )
    );
  }
}