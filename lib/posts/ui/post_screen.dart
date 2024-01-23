import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_block/posts/bloc/post_bloc.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final PostBloc _postBloc = PostBloc();

  @override
  void initState() {
    _postBloc.add(PostinitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: BlocConsumer<PostBloc, PostState>(
          bloc: _postBloc,
          listenWhen: (previous, current) => current is PostActionstate,
          buildWhen: (previous, current) => current is! PostActionstate,
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.runtimeType) {
              case PostLoadingSate:
                return const Center(child: CircularProgressIndicator());
              case PostFetchSuccessState:
                final successSate = state as PostFetchSuccessState;

                final data = successSate.postDataList;

                return data.isEmpty
                    ? const Center(child: Text('No data found'))
                    : ListView.builder(
                        itemCount: data.length,
                        itemBuilder: ((context, index) {
                          return Text(data[index].title);
                        }));
              default:
                return Container();
            }
          }),
    );
  }
}
