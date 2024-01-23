import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_block/home/bloc/home_bloc.dart';
import 'package:learning_block/meditation_screen/ui/meditation_screen.dart';
import 'package:learning_block/profile/cubit/user_cubit.dart';
import 'package:learning_block/profile/ui/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  logoutTemp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hi Pravin, welcome',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    logoutTemp();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (ctx) => const ProfileScreen()));
                  },
                  child: Container(
                    width: 46,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xff1b1d22)),
                    child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        switch (state.runtimeType) {
                          case UserLoaded:
                            final successState = state as UserLoaded;
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: successState.user.profilepic,
                                fit: BoxFit.cover,
                              ),
                            );
                          default:
                            return const Icon(
                              Icons.person,
                              color: Colors.white,
                            );
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case HomeInitial:
                    context.read<HomeCubit>().getMeditationCategoryData();
                    return const SizedBox();
                  case HomeMeditaionCategoryFetchSuccess:
                    final successState =
                        state as HomeMeditaionCategoryFetchSuccess;
                    return Column(
                      children: successState.meditationCategoryList
                          .map((data) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => MeditationScreen(
                                                img: data.img,
                                                cateogaryId: data.id,
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 180,
                                        width: double.infinity,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            imageUrl: data.img,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          child: Container(
                                            // height: 20,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),

                                            decoration: BoxDecoration(
                                              color: Colors.black
                                                  .withOpacity(0.55),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(15),
                                                      bottomRight:
                                                          Radius.circular(15)),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                48,
                                            child: Text(
                                              data.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  default:
                    return const SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
