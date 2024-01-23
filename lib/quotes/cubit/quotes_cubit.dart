import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning_block/quotes/model/quotes_data_model.dart';
import 'package:meta/meta.dart';

part 'quotes_state.dart';

class QuotesCubit extends Cubit<QuotesState> {
  QuotesCubit() : super(QuotesInitial());

  final CollectionReference _meditationCategoryCollectionRef =
      FirebaseFirestore.instance.collection('quotes');

  Future<void> getQuotesData() async {
    try {
      QuerySnapshot querySnapshot =
          await _meditationCategoryCollectionRef.get();

      final quotesDataList = querySnapshot.docs
          .map((e) => QuotesDataModel.fromJson(
              e.data() as Map<String, dynamic>..addAll({"id": e.id})))
          .toList();
      emit(QuotesDataFetchSuccess(quotesDataList: quotesDataList));
    } catch (e) {
      print(e.toString());
    }
  }
}
