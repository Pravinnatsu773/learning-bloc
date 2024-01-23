import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_block/home/model/meditation_category_model.dart';
import 'package:learning_block/home/model/meditation_data_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final CollectionReference _meditationCategoryCollectionRef =
      FirebaseFirestore.instance.collection('meditation-categories');

  Future<void> getMeditationCategoryData() async {
    try {
      QuerySnapshot querySnapshot =
          await _meditationCategoryCollectionRef.get();

      final meditationCategoryList = querySnapshot.docs
          .map((e) => MeditationCategoryModel.fromJson(
              e.data() as Map<String, dynamic>..addAll({"id": e.id})))
          .toList();
      emit(HomeMeditaionCategoryFetchSuccess(
          meditationCategoryList: meditationCategoryList));
    } catch (e) {
      print(e.toString());
    }
  }
}
