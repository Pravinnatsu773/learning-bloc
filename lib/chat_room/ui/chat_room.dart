import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learning_block/groups/cubit/group_cubit.dart';
import 'package:learning_block/groups/model/member_model.dart';
import 'package:learning_block/utils/bloc_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String id;
  final List<Member> members;
  final bool isMember;
  final String groupName;

  const ChatScreen(
      {super.key,
      required this.id,
      required this.members,
      required this.isMember,
      required this.groupName});
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  bool isMember = false;

  List<Member> members = [];
  @override
  void initState() {
    setState(() {
      isMember = widget.isMember;
      members = widget.members;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111315),
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        actions: [
          isMember
              ? const SizedBox()
              : GestureDetector(
                  onTap: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    final String uid = prefs.getString('uid') ?? '';

                    BlocHelper.groupCubit
                        .joinGroup(gropupId: widget.id)
                        .then((isSuccess) {
                      final successState =
                          BlocHelper.groupCubit.state as GroupDataFetchSuccess;
                      final latestMembers = successState.groups
                          .where((element) => element.id == widget.id)
                          .toList()
                          .first
                          .members;
                      setState(() {
                        members = latestMembers;

                        isMember = latestMembers
                            .where((element) => element.uid == uid)
                            .toList()
                            .isNotEmpty;
                      });
                    });
                  },
                  child: Text(
                    'Join',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
          const SizedBox(
            width: 24,
          )
        ],
        backgroundColor: const Color(0xff1b1d22),
        title: Text(
          widget.groupName,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('message')
                  .doc(widget.id)
                  .collection('messages')
                  .orderBy('sentAt')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: Text('No messages yet.'),
                  );
                } else {
                  print(snapshot.data);

                  var messages = snapshot.data!.docs.reversed;

                  List<Widget> messageWidgets = [];
                  for (var message in messages) {
                    final messageText = message['text'];

                    final messageSenderId = message['senderId'];
                    final messageSenderName = message['senderName'];

                    final messageSenderProfilePic = members
                        .where((member) => member.uid == messageSenderId)
                        .toList()
                        .first
                        .profilePic;

                    final messageWidget = MessageWidget(
                        messageSenderId,
                        messageSenderName,
                        messageText,
                        messageSenderProfilePic);
                    messageWidgets.add(messageWidget);
                  }

                  return ListView(
                    reverse: true,
                    controller: _scrollController,
                    children: messageWidgets,
                  );
                }
              },
            ),
          ),
          isMember ? _buildMessageComposer() : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 100,
      ),
      child: Container(
        // height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: const BoxDecoration(
          color: Color(0xff1b1d22),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
                maxLines: null, // Allows for unlimited lines
                keyboardType: TextInputType.text,
                controller: _messageController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: () {
                _sendMessage();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String uid = prefs.getString('uid') ?? '';
    if (_messageController.text.isNotEmpty) {
      await _firestore
          .collection('message')
          .doc(widget.id)
          .collection('messages')
          .add({
        'text': _messageController.text,
        'senderId': uid,
        'senderName': 'Pravin Choudhary',
        'sentAt': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}

class MessageWidget extends StatefulWidget {
  final String sender;
  final String name;
  final String text;
  final String profilePic;

  MessageWidget(this.sender, this.name, this.text, this.profilePic);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.white.withOpacity(0.55), width: 0.25))),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                child: CachedNetworkImage(
                  imageUrl: widget.profilePic,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '2h ago',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Colors.white.withOpacity(0.55),
                        ),
                  ),
                  // Text(text),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              widget.text,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
