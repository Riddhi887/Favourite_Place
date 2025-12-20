//manages the places that are selectes or added by user using the riverpod package
import 'dart:convert';
import 'dart:io';
import 'package:favourite_place/models/place.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path_provider/path_provider.dart' as sysPaths;
import 'package:path/path.dart' as path;

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  //constructor function UserPlacesNotifier() that points to the parent class using super and gives initial state here is empty list ... state managed by riverpod must not be added to the memory
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final appDir = await sysPaths.getApplicationDocumentsDirectory();
    final file = File(
      '${appDir.path}/places_data.json',
    ); //to store location data locally

    if (!await file.exists()) {
      return;
    }

    //convert json item back to place object by taking each item from list 
    final jsonString = await file.readAsString();
    final List<dynamic> jsonData = json.decode(jsonString);

    final places = jsonData.map((item) {
      return Place(
        title: item['title'],
        image: File(item['imagePath']),
        location: PlaceLocation(
          latitude: item['latitude'],
          longitude: item['longitude'],
          address: item['address'],
        ),
      );
    }).toList();

    state = places;
  }

  //method that allows us to add new place using the riverpod by creating a new object
  //NOTE: we cannot directly add old object to memory instead have to create new obj
  void addPlace(String title, File image, PlaceLocation location) async {
    //get the path of the place to store it locally on device
    final appDir = await sysPaths.getApplicationDocumentsDirectory();

    final filename = path.basename(image.path); //to store image locally

    //copy the image to particular path (as string) first seg from appDir and another from filename
    //copy method has Future
    final copiedImage = await image.copy('${appDir.path}/$filename');

    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: location,
    );
    state = [
      newPlace,
      ...state,
    ]; //initate a new list and add new place to it ... is used to seperate all elements in list

    //  SAVE TO JSON FILE 
    final file = File('${appDir.path}/places_data.json');

     // Convert all places to JSON format
    final placesData = state.map((place) {
      return {
        'title': place.title,
        'imagePath': place.image.path,    // Save the path not img 
        'latitude': place.location.latitude,
        'longitude': place.location.longitude,
        'address': place.location.address,
      };
    }).toList();

    //Write JSON to file
    await file.writeAsString(json.encode(placesData));
  }
}

//StateNotifierProvider will take UserPlacesNotifier, List<Place> as parameter to watch it and display it tells dart userPlaces in places.dart is actually list of places of user
final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
      (ref) => UserPlacesNotifier(),
    );
