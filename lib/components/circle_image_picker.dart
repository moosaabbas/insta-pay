import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class CircleImagePicker extends StatefulWidget {
   
  const CircleImagePicker({super.key, required this.callback}); 
  @override
  State<CircleImagePicker> createState() => _ImagePicker();
  final Function(String) callback;
}

class _ImagePicker extends State<CircleImagePicker> {

  _ImagePicker();
  late Function(String) callback;
  dynamic _image;
  String imageURL = 'NULL';
  
  Future getImage() async {

    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemp = File(image.path);

    setState(() {
      _image = imageTemp;
    });
    
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child('${image.path}');
    
    try{
    await referenceImageToUpload.putFile(File(image.path));
    imageURL = await referenceImageToUpload.getDownloadURL();
    callback(imageURL);
    } catch(e){ 
      return;
    }
  }

  @override
  void initState(){
    super.initState();
    callback = widget.callback;
  }

@override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        getImage();
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: _image != null ? FileImage(_image) as ImageProvider : const AssetImage('assets/images/profile_avatar.png',),
      ),
    ),
      ),
    );
  }
}
