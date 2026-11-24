import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore base = FirebaseFirestore.instance;

  Stream<QuerySnapshot> obtenerPublicaciones() {
    return base
        .collection('publicaciones')
        .orderBy('fechaCreacion', descending: true)
        .snapshots();
  }

  Future<void> cambiarEstado(String id, String nuevoEstado) async {
  await base.collection('publicaciones').doc(id).update({
    'estado': nuevoEstado,
  });
  }

  Future<List<String>> obtenerCategorias() async {
    try{
      QuerySnapshot snapshot = await base.collection('categorias').get();
    
      return snapshot.docs.map((doc) => doc['nombre'].toString()).toList();

    }catch(e){
      print("Error al intentar obtener categorias $e");
      return [];
    }
  }

  Stream<QuerySnapshot> misPublicaciones(){
    final User? usuario  = FirebaseAuth.instance.currentUser;
    final String correo = usuario?.email ?? '';
    return base
    .collection('publicaciones')
    .where('autorCorreo', isEqualTo: correo)
    .snapshots();

  }

 
  Future<Map<String, dynamic>> publicar({
    required String titulo,
    required String descripcion,
    required String tipo,
    required String categoria,
    required String lugar,
    required String foto,

  })async{
    Map<String, dynamic> erroresValidacion = {};

    if (titulo.isEmpty) {
      erroresValidacion['nombre'] = ['El título es obligatorio.'];
    }
    if (descripcion.isEmpty) {
      erroresValidacion['descripcion'] = ['La descripción es obligatoria.'];
    }
    if (tipo.isEmpty) {
      erroresValidacion['tipo'] = ['Debe seleccionar un tipo.'];
    }
    if (categoria.isEmpty) {
      erroresValidacion['categoria'] = ['Debe seleccionar una categoría.'];
    }
    if (lugar.isEmpty) {
      erroresValidacion['lugar'] = ['El lugar es obligatorio.'];
    }
    if (foto.isEmpty){
      erroresValidacion['foto'] = ['Debe agregar una foto del objeto.'];
    }

   
    if (erroresValidacion.isNotEmpty) {
      return {'errors': erroresValidacion};
    }




    try{
      final User? usuario = FirebaseAuth.instance.currentUser;

      await base.collection('publicaciones').add({
        'titulo':titulo,
        'descripcion':descripcion,
        'tipo':tipo,
        'categoria':categoria,
        'lugar':lugar,
        'foto': foto,
        'estado': 'Vigente',
        'autorNombre':usuario?.displayName ?? 'Anonimo',
        'autorCorreo':usuario?.email ?? '',
        'fechaCreacion': FieldValue.serverTimestamp(),

      });
      return {'estatus':'ok'};
    }catch(e){
      return{
        'firebase':['Error al guardar en la base de datos: $e']
      };
    }
  }
}