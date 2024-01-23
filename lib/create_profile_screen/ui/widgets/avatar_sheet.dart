import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_block/create_profile_screen/cubit/create_profile_cubit.dart';

class AvatarSheet extends StatefulWidget {
  const AvatarSheet({super.key, required this.setImage});
  final Function(String) setImage;
  @override
  State<AvatarSheet> createState() => _AvatarSheetState();
}

class _AvatarSheetState extends State<AvatarSheet> {
  String selectedImage = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
          color: Color(0xff1b1d22),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Select an avatar',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<CreateProfileCubit, CreateProfileState>(
              builder: (context, state) {
            switch (state.runtimeType) {
              case CreateProfileInitial:
                context.read<CreateProfileCubit>().fetchAvatars();
                return const CircularProgressIndicator();
              case CreateProfileAvatarFetchSuccess:
                final successState = state as CreateProfileAvatarFetchSuccess;
                return Expanded(
                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: successState.images.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImage = successState.images[index];
                            });
                          },
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: successState.images[index],
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                  top: 4,
                                  right: 4,
                                  child: successState.images[index] ==
                                          selectedImage
                                      ? const CircleAvatar(
                                          backgroundColor: Colors.green,
                                          radius: 12,
                                          child: Icon(Icons.check,
                                              color: Colors.white))
                                      : const SizedBox())
                            ],
                          ),
                        );
                      }),
                );
              default:
                return const Text(
                  'No data found',
                  style: TextStyle(color: Colors.white),
                );
            }
          }),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    widget.setImage(selectedImage);
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    // width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.deepPurple),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
