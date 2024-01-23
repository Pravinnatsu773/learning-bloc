import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning_block/home/model/meditation_data_model.dart';
import 'package:meta/meta.dart';

part 'meditation_state.dart';

class MeditationCubit extends Cubit<MeditationState> {
  MeditationCubit() : super(MeditationInitial());

  final CollectionReference _meditationCategoryCollectionRef =
      FirebaseFirestore.instance.collection('meditation-categories');

  Future<void> getMeditationData({required String docId}) async {
    try {
      QuerySnapshot querySnapshot = await _meditationCategoryCollectionRef
          .doc(docId)
          .collection('all-sounds')
          .get();

      final meditationDataList = querySnapshot.docs
          .map((e) => MeditationDataModel.fromJson(
              e.data() as Map<String, dynamic>..addAll({"id": e.id})))
          .toList();

      emit(MeditaionDataFetchSuccess(meditationDataList: meditationDataList));
    } catch (e) {
      print(e.toString());
    }
  }
}
