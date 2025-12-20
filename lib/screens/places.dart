import 'package:favourite_place/providers/user_places.dart';
import 'package:favourite_place/screens/add_place.dart';
import 'package:favourite_place/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlacesScreeState();
  }
}

class _PlacesScreeState extends ConsumerState<PlacesScreen> {
  late Future<void>
  _placesFuture; //this value not set initally but will be set in future

  //to set up the future we use init state (initial state)
  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces(); 
    //loads the state using Provider and store Future in _placesFuture
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          'Your Places',
          style: GoogleFonts.poppins(
            // choose any Google font
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, size: 30),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const AddPlaceScreen()),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),

        //show PlacesList only if done fetching from the database can be done using FutureBuilder
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : PlacesList(
                  places: userPlaces, //places_list.dart from widget folder
                ),
        ),
      ),
    );
  }
}
