import 'package:favourite_place/providers/user_places.dart';
import 'dart:io';
import 'package:favourite_place/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreen();
  }
}

class _AddPlaceScreen extends ConsumerState<AddPlaceScreen> {
  //creating controller
  final _titleController = TextEditingController();
  //get the selected image / captured image
  File? _selectedImage;

  //saving the text
  void _savePlace() {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Invalid Input',
            style: GoogleFonts.poppins(
              // choose any Google font
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          content: Text(
            'Please enter your place name.',
            style: GoogleFonts.poppins(
              // choose any Google font
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            ElevatedButton(
              onPressed: Navigator.of(ctx).pop,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 80, 59, 116),
                ),
              ),
              child: Text(
                'Ok',
                style: GoogleFonts.aBeeZee(
                  // choose any Google font
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    //accessing the provider
    ref.read(userPlacesProvider.notifier).addPlace(enteredTitle, _selectedImage!);

    Navigator.of(context).pop();
  }

  //disposing controller after use
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          'Add new Places',
          style: GoogleFonts.poppins(
            // choose any Google font
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: GoogleFonts.poppins(fontSize: 15),
              ),
              controller:
                  _titleController, //flutter manages the user input for you
              style: GoogleFonts.aBeeZee(
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

            const SizedBox(height: 20),

            //Image Input
            ImageInput(
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: Icon(Icons.add),
              label: Text(
                'Add Place',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
