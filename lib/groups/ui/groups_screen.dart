import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_block/chat_room/ui/chat_room.dart';
import 'package:learning_block/groups/cubit/group_cubit.dart';
import 'package:learning_block/groups/ui/widgets/group_bottom_sheet.dart';
import 'package:learning_block/utils/bloc_helper.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Groups',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      showCreateGroupSheet(context);
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              BlocBuilder<GroupCubit, GroupState>(
                bloc: BlocHelper.groupCubit,
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case GroupInitial:
                      BlocHelper.groupCubit.getGroups();
                      return const SizedBox();
                    case GroupDataFetchSuccess:
                      final successState = state as GroupDataFetchSuccess;
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: successState.groups.length,
                          itemBuilder: (context, index) {
                            final data = successState.groups[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                tileColor: const Color(0xff1b1d22),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => ChatScreen(
                                                members: data.members,
                                                id: data.id,
                                                isMember: data.isMember,
                                                groupName: data.name,
                                              )));
                                },
                                leading: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.2),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: CachedNetworkImage(
                                      imageUrl: data.img,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  data.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${data.members.length} members',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: Colors.white.withOpacity(0.55),
                                      ),
                                ),
                                trailing: data.isMember
                                    ? null
                                    : GestureDetector(
                                        onTap: () {
                                          BlocHelper.groupCubit.joinGroup(
                                            gropupId: data.id,
                                          );
                                        },
                                        child: Text(
                                          'Join',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                              ),
                            );
                          });

                    default:
                      return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  showCreateGroupSheet(
    context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      useSafeArea: true,
      builder: (BuildContext ctx) {
        return GroupBottomSheet(mainScreenContext: context);
      },
    );
  }
}
