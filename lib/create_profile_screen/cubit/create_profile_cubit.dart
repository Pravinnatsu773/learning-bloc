import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'create_profile_state.dart';

class CreateProfileCubit extends Cubit<CreateProfileState> {
  CreateProfileCubit() : super(CreateProfileInitial());

  final FirebaseStorage storage = FirebaseStorage.instance;

  final CollectionReference _avatarCollectionRef =
      FirebaseFirestore.instance.collection('avatar');
  final CollectionReference _usersCollectionRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> fetchAvatars() async {
    try {
      QuerySnapshot querySnapshot = await _avatarCollectionRef.get();

      final data = querySnapshot.docs.first.data() as Map<String, dynamic>;

      emit(CreateProfileAvatarFetchSuccess(images: data['avatars']));
    } catch (e) {
      print('Error fetching avatars: $e');
    }
  }

  Future<void> createUserProfile(
      {required String profilePic, required String name}) async {
    emit(CreateProfileLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final String uid = prefs.getString('uid') ?? '';

      await _usersCollectionRef.doc(uid).set({
        'profile-pic': profilePic,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
        'id': uid,
        'modifiedAt': FieldValue.serverTimestamp(),
      });

      prefs.setString('profile-pic', profilePic);

      prefs.setString('name', name);

      emit(CreateProfileSuccess());
    } catch (e) {
      print(e);
      emit(CreateProfileInitial());
    }
  }
}
