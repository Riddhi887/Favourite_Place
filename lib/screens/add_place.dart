import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddPlaceScreen();
  }
}

class _AddPlaceScreen extends State<AddPlaceScreen> {

  //creating controller
  final _titleController = TextEditingController();

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
              decoration:  InputDecoration(
                labelText: 'Title', labelStyle: GoogleFonts.poppins(fontSize: 15),),
                controller: _titleController,         //flutter manages the user input for you
                style: GoogleFonts.aBeeZee(
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              ),
            
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: (){}, 
              icon: Icon(Icons.add),
              label:  Text(
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
