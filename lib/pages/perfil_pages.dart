import 'package:flutter/material.dart';
import 'package:flutter_abner_cristian_1/app_colors.dart';
import '../services/firestore_service.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class PerfilPages extends StatefulWidget {
  const PerfilPages({super.key});

  @override
  State<PerfilPages> createState() => PerfilPagesState();
}

class PerfilPagesState extends State<PerfilPages> {

  final nombreCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();
  final lugarCtrl = TextEditingController();

  String? tipoSelec;
  String? categoriaSelec;

  bool guardando = false;
  Map<String, dynamic> errores = {};

  List<String>categorias =  [];
  bool cargandoCategorias = true;


  String? fotoSubida;

  Future<void> seleccionarFoto(ImageSource origen) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(
      source: origen,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 50,
    );

    if (imagen != null) {
      final bytes = await imagen.readAsBytes();
      setState(() {
        fotoSubida = base64Encode(bytes);
      });
    }
  }

   @override
  void initState() {
    
    super.initState();
    cargarCatego();
  }

  Future<void>cargarCatego() async {
    final categoriasObtenidas = await FirestoreService().obtenerCategorias();
    if (mounted){
      setState(() {
        categorias = categoriasObtenidas;
        cargandoCategorias = false;
      });
    }
  }
  void limpiarForm() {
    nombreCtrl.clear();
    descripcionCtrl.clear();
    lugarCtrl.clear();
    setState(() {
      tipoSelec= null;
      categoriaSelec = null;

      fotoSubida = null;
      errores = {};
    });
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    descripcionCtrl.dispose();
    lugarCtrl.dispose();
    super.dispose();     
  }

  Widget build(BuildContext context) {
    if(cargandoCategorias){
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: EdgeInsetsGeometry.all(15),
      child: Form(
        child: ListView(
          children: [
            Text('Ingresa los datos de tu Objeto Perdido:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height:20),
            TextFormField(
              controller: nombreCtrl,
              decoration: InputDecoration(
                labelText: 'Título (Ej: Audífonos negros)',
                errorText: errores['nombre']?[0],
              ),
            ),
            SizedBox(height: 10),

            TextFormField(
              controller: descripcionCtrl,
              decoration: InputDecoration(
                labelText: 'Descripción',
                errorText: errores['descripcion']?[0],
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: lugarCtrl,
              decoration: InputDecoration(
                labelText: 'Lugar donde se perdió/encontró',
                errorText: errores['lugar']?[0],
              ),
            ),

          //tipo
            SizedBox(height: 10,),

            DropdownButtonFormField<String>(
              value: tipoSelec,
              decoration: InputDecoration(
                labelText: 'Tipo',
                errorText: errores['tipo']?[0],
              ), // InputDecoration
              items: ['Perdido', 'Encontrado'].map((String valor) {
                return DropdownMenuItem<String>(
                  value: valor,
                  child: Text(valor),
                ); // DropdownMenuItem
              }).toList(),
              onChanged: (value) => setState(() => tipoSelec = value),
            ),

          //categoria
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: categoriaSelec,
              decoration: InputDecoration(
                labelText: 'Categoria',
                errorText: errores['categoria']?[0],
              ),
              items: categorias.map((String categ){
                return DropdownMenuItem<String>(
                  value: categ,
                  child: Text(categ),
                );
              }).toList(),
              onChanged: (value) => setState(() => categoriaSelec = value),

            ),

          //foto
          SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.cbotones,
                    side:  BorderSide(color: AppColors.cappbar)

                  ),
                  onPressed: () => seleccionarFoto(ImageSource.camera),
                  icon: Icon(Icons.camera_alt),
                  label: Text('Cámara'),
                ),

                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.cbotones,
                    side:  BorderSide(color: AppColors.cappbar)

                  ),
                  onPressed: () => seleccionarFoto(ImageSource.gallery),
                  icon: Icon(Icons.photo_library),
                  label: Text('Galería'),
                ),
              ],
            ),

            if (fotoSubida != null) ...[
              SizedBox(height: 10),
              Image.memory(
                base64Decode(fotoSubida!),
                height: 150,
                fit: BoxFit.cover,
              ),
            ],

            if (errores['foto'] != null)
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  errores['foto'][0],
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),





            //boton
            SizedBox(height: 30),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.cbotones,
                foregroundColor: AppColors.cbordes,
              ),
              onPressed: () async{
                if(guardando){
                  return;
                }
                guardando = true;
                final mensaje = ScaffoldMessenger.of(context);

                try{
                  var respuesta = await FirestoreService().publicar(
                    titulo: nombreCtrl.text.trim(), 
                    descripcion: descripcionCtrl.text.trim(),
                     tipo: tipoSelec ?? '', 
                     categoria: categoriaSelec ?? '', 
                     lugar: lugarCtrl.text.trim(),
                     foto: fotoSubida ?? '',
                     );

                    //si se sale
                    if(!context.mounted){
                      return;
                    }
                    if(respuesta.containsKey('errors')){
                      setState(() {
                        errores = respuesta['errors'];
                      });
                      return;
                    }

                    limpiarForm();

                    mensaje.showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 3),
                        backgroundColor: AppColors.cIndicador,
                        content: Text('Objeto publicado en Firebase'),
                      ),
                    );
                }finally {
                  guardando = false;
              }
              },
              child: Text('Publicar Objeto',style: TextStyle(color: Colors.white),),
            ),
          
          ],
        ),
      ),
    );
  }
}