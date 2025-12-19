//manages the places that are selectes or added by user using the riverpod package
import 'dart:io';
import 'package:favourite_place/models/place.dart';
import 'package:flutter_riverpod/legacy.dart';


class UserPlacesNotifier extends StateNotifier<List<Place>> {
  //constructor function UserPlacesNotifier() that points to the parent class using super and gives initial state here is empty list ... state managed by riverpod must not be added to the memory
  UserPlacesNotifier() : super(const []);

  //method that allows us to add new place using the riverpod by creating a new object
  //NOTE: we cannot directly add old object to memory instead have to create new obj
  void addPlace(String title, File image, PlaceLocation location) {
    final newPlace = Place(title: title, image: image, location: location);
    state = [
      newPlace,
      ...state,
    ]; //initate a new list and add new place to it ... is used to seperate all elements in list
  }
}

//StateNotifierProvider will take UserPlacesNotifier, List<Place> as parameter to watch it and display it tells dart userPlaces in places.dart is actually list of places of user
final userPlacesProvider = StateNotifierProvider<UserPlacesNotifier, List<Place>>
(
  (ref) => UserPlacesNotifier(),
);
