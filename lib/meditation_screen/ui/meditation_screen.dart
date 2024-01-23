import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_block/data/quotes_data.dart';
import 'package:learning_block/meditation_screen/cubit/meditation_cubit.dart';
import 'package:learning_block/music_player/music_player.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen(
      {super.key, required this.img, required this.cateogaryId});
  final String img;
  final String cateogaryId;

  static List imgList = [
    'https://images.pexels.com/photos/4908995/pexels-photo-4908995.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://a.storyblok.com/f/60579/1200x628/7be929f8e6/mtg_fbshare_en.jpg',
    'https://images.pexels.com/photos/19730553/pexels-photo-19730553/free-photo-of-birds-eye-view-of-the-seashore.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://a.storyblok.com/f/60579/1200x628/cea021e22e/fb-sharer-mvcom.jpg',
    'https://images.pexels.com/photos/957024/forest-trees-perspective-bright-957024.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://a.storyblok.com/f/60579/1920x1080/4e49353f28/6pm_questcover_en.jpg',
    'https://i.ytimg.com/vi/9hnicI0_QGg/maxresdefault.jpg',
    'https://images.pexels.com/photos/40192/woman-happiness-sunrise-silhouette-40192.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://www.jeyjetter.com/wp-content/uploads/2020/08/meditation-600x314.jpg'
  ];

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final MeditationCubit _meditationCubit = MeditationCubit();
  @override
  void initState() {
    _meditationCubit.getMeditationData(docId: widget.cateogaryId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111315),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            // leadingWidth: 0,
            automaticallyImplyLeading: false,
            floating: true,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xff111315),
            pinned: true,
            flexibleSpace: Align(
              alignment: Alignment.bottomRight,
              child: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl: widget.img,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          BlocBuilder<MeditationCubit, MeditationState>(
            bloc: _meditationCubit,
            builder: (context, state) {
              switch (state.runtimeType) {
                case MeditaionDataFetchSuccess:
                  final successState = state as MeditaionDataFetchSuccess;
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final data = successState.meditationDataList[index];
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => MusicScreen(
                                              data: data,
                                            )));
                              },
                              leading: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: CachedNetworkImage(
                                  imageUrl: data.img,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                data.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: const Text(
                                '4 min',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const Divider(
                              color: Color(
                                  0xff1b1d22), // Adjust the color of the divider as needed
                              thickness:
                                  1.0, // Adjust the thickness of the divider as needed
                            ),
                          ],
                        );
                      },
                      childCount: successState.meditationDataList
                          .length, // Adjust the number of list items as needed
                    ),
                  );
                default:
                  return SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return SizedBox();
                    },
                    childCount: 0,
                  ));
              }
            },
          ),
        ],
      ),
    );
  }
}
