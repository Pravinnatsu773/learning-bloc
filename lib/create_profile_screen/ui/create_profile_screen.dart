import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_block/create_profile_screen/cubit/create_profile_cubit.dart';
import 'package:learning_block/create_profile_screen/ui/widgets/avatar_sheet.dart';
import 'package:learning_block/shell/ui/shell.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  // final CreateProfileCubit _createProfileCubit = CreateProfileCubit();
  String profilePic = '';

  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111315),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create your profile',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () {
                  // _pickFile();
                  showAvatarBottomSheet(context);
                },
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: profilePic.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: profilePic,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 36,
                        ),
                ),
              ),
              const SizedBox(
                height: 46,
              ),
              TextField(
                controller: _nameController,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xff111315),
                    hintText: 'Enter your name',
                    hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50))),
              ),
              const Expanded(child: SizedBox()),
              BlocConsumer<CreateProfileCubit, CreateProfileState>(
                listener: (context, state) {
                  if (state is CreateProfileSuccess) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Shell()),
                        (route) => false);
                  }
                },
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case CreateProfileLoading:
                      return const CircularProgressIndicator();
                    default:
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                context
                                    .read<CreateProfileCubit>()
                                    .createUserProfile(
                                        profilePic: profilePic,
                                        name: _nameController.text);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                // width: MediaQuery.of(context).size.width * 0.6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.deepPurple),
                                child: Text(
                                  'continue'.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  showAvatarBottomSheet(
    context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      useSafeArea: true,
      builder: (BuildContext ctx) {
        return AvatarSheet(
          setImage: (img) {
            setState(() {
              profilePic = img;
            });
          },
        );
      },
    );
  }
}
