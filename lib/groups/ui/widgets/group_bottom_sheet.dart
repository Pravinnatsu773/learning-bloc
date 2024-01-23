import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_block/groups/cubit/group_cubit.dart';
import 'package:learning_block/utils/bloc_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupBottomSheet extends StatefulWidget {
  const GroupBottomSheet({super.key, required this.mainScreenContext});
  final BuildContext mainScreenContext;

  @override
  State<GroupBottomSheet> createState() => _GroupBottomSheetState();
}

class _GroupBottomSheetState extends State<GroupBottomSheet> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  TextEditingController _groupNameController = TextEditingController();

  File? _image;
  bool isUploading = false;

  Future<void> _pickFile() async {
    // Pick an image from gallery
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future<void> _uploadImage(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String uid = prefs.getString('uid') ?? '';

    final String profilePic = prefs.getString('profile-pic') ?? '';

    try {
      setState(() {
        isUploading = true;
      });
      // Upload image to Firebase Storage
      Reference ref = _storage.ref().child('images/${DateTime.now()}.png');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      // Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save download URL to Firestore
      final c = _firestore.collection('groups');

      await c.add({
        'img': downloadUrl,
        'name': _groupNameController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': uid,
        'members': [
          {'id': uid, 'profile-pic': profilePic}
        ],
        'modifiedAt': FieldValue.serverTimestamp(),
      });

      BlocHelper.groupCubit.getGroups();

      Navigator.pop(context);

      print('Image uploaded successfully!');
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
          color: Color(0xff1b1d22),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Create a group',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              _pickFile();
            },
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
              ),
              child: _image != null
                  ? Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                ),
            controller: _groupNameController,
            decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xff111315),
                hintText: 'Enter Group name',
                hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50))),
          ),
          const SizedBox(
            height: 20,
          ),
          isUploading
              ? const CircularProgressIndicator()
              : Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          _uploadImage(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          // width: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.deepPurple),
                          child: const Text(
                            'Create Group',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
