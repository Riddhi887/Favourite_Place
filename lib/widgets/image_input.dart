import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  //method to open camera and take pictures
  //used image_picker package
  void _takePicture() {
    
  }
  @override
  Widget build(BuildContext context) {
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
      child: TextButton.icon(
        icon: Icon(Icons.camera_alt, size: 30),
        label: Text(
          'Capture Image',
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400),
        ),
        onPressed: _takePicture,
      ),
    );
  }
}
