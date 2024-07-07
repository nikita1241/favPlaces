import 'dart:io'; //file

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  //for preview img
  File? _selectedImage; //can be null

  void _takePicture() async {
    final imagePicker = ImagePicker(); //to pic image from phone(already existing) or by camera
    
    // returns future as Xfile
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600); //for new img by cam

    if (pickedImage == null) { //if took no pic
      return;
    }

//to update ui
    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);//frwd it
  }

//ui
  @override
  Widget build(BuildContext context) {

    //camera icon to take pic
    Widget content = TextButton.icon(
      icon: const Icon(Icons.camera),
      label: const Text('Take Picture'),
      onPressed: _takePicture,
    );

    if (_selectedImage != null) {

      content = GestureDetector(//to make image tapable to replace img with new img
        onTap: _takePicture,
        //preview //image wants type file
        child: Image.file(
          _selectedImage!,
          //to fit img //but crops it
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration( //blank box border and centered inside is take pic
        border: Border.all(
          width: 1, //border width
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}