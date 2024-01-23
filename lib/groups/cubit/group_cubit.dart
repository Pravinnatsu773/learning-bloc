// ignore_for_file: use_build_context_synchronously

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_block/groups/model/group_model.dart';
import 'package:learning_block/utils/bloc_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitial());

  final CollectionReference _groupCollectionRef =
      FirebaseFirestore.instance.collection('groups');

  Future<void> getGroups() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String uid = prefs.getString('uid') ?? '';

    try {
      print("##################################");
      QuerySnapshot querySnapshot = await _groupCollectionRef.get();

      List<Map<String, dynamic>> d = querySnapshot.docs
          .map((e) => e.data() as Map<String, dynamic>
            ..addAll({
              "id": e.id,
            }))
          .toList();

      final groups = d.map((e) {
        List memberList = e['members'];

        print(e);
        e.addAll({
          'isMember':
              memberList.where((a) => a['id'] == uid).toList().isNotEmpty
        });
        return GroupModel.fromJson(e);
      }).toList();

      emit(GroupDataFetchSuccess(groups: groups));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> joinGroup({required String gropupId}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String uid = prefs.getString('uid') ?? '';
    final String profilePic = prefs.getString('profile-pic') ?? '';

    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(gropupId)
          .update({
        'members': FieldValue.arrayUnion([
          {'id': uid, 'profile-pic': profilePic}
        ])
      });

      await BlocHelper.groupCubit.getGroups();
      return true;
    } catch (e) {
      // TODO
      return false;
    }
    // emit(GroupInitial());
  }
}
