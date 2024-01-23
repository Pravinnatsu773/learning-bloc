import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_block/posts/models/post_data_model.dart';
import 'package:learning_block/posts/repository/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<PostinitialFetchEvent>(postinitialFetchEvent);
  }

  FutureOr<void> postinitialFetchEvent(
      PostinitialFetchEvent event, Emitter<PostState> emit) async {
    emit(PostLoadingSate());

    List<PostDataModel> postDataList = await PostRepository.fectPostdata();

    emit(PostFetchSuccessState(postDataList: postDataList));
  }
}
