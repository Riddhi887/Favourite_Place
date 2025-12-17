import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  //get the captured image to display it on details screen or other screen 
  //method/ function created to forwaerd the PickedImage from child to parent class
  final void Function(File image) onPickImage;

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage; 
  //the variable of type file will store the captured image? bcz it can be null too depends

  //method to open camera and take pictures
  //used image_picker package
  //used async and await cause pickImage has a Future
  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    //if user on camera but doesnot take photo
    if (pickedImage == null) {
      return;
    }

    //if the image was captured by the user
    //here the pickedImage is type of XFile and we converted it to normal file by passing the path of pickedImage
    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);    //to forward the selected image to parent class
  }

  @override
  Widget build(BuildContext context) {
    //if no image capture then display
    Widget content = TextButton.icon(
      icon: Icon(Icons.camera_alt, size: 30),
      label: Text(
        'Capture Image',
        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400),
      ),
      onPressed: _takePicture,
    );

    //if the image is present or capture display it
    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withValues(),
        ),
      ),
      height: 245,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
