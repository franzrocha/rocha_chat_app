
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rocha_chat_app/controllers/auth_controller.dart';
import 'package:rocha_chat_app/controllers/chat_controller.dart';
import 'package:rocha_chat_app/models/chat_message_model.dart';
import 'package:rocha_chat_app/models/chat_user_model.dart';
import 'package:rocha_chat_app/service_locators.dart';
import 'package:rocha_chat_app/services/image_service.dart';
import 'package:simple_moment/simple_moment.dart';

import '../../widgets/avatar.dart';

class HomeScreen extends StatefulWidget {
  static const String route = 'home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _auth = locator<AuthController>();
  final ChatController _chatController = ChatController();

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFN = FocusNode();
  final ScrollController _scrollController = ScrollController();

  ChatUser? user;
  @override
  void initState() {
    ChatUser.fromUid(uid: _auth.currentUser!.uid).then((value) {
      if (mounted) {
        setState(() {
          user = value;
        });
      }
    });
    _chatController.addListener(scrollToBottom);
    super.initState();
  }

  @override
  void dispose() {
    _chatController.removeListener(scrollToBottom);
    _messageFN.dispose();
    _messageController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 250));
    print('scrolling to bottom');
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 250));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user != null ? user!.username : '. . .',  
          style: GoogleFonts.openSans(  
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xff333d79),
        actions: [
          InkWell(
            onTap: () {
              ImageService.updateProfileImage();
            },
            child: AvatarImage(uid: FirebaseAuth.instance.currentUser!.uid),
          ),
          const SizedBox(
            width: 8,
          ),
          IconButton(
              onPressed: () async {
                _auth.logout();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: AnimatedBuilder(
                  animation: _chatController,
                  builder: (context, Widget? w) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      controller: _scrollController,
                      child: Column(
                        children: [
                          for (ChatMessage chat in _chatController.chats)
                            ChatCard(chat: chat)
                        ],
                      ),
                    );
                  }),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onFieldSubmitted: (String text) {
                        send();
                      },
                      focusNode: _messageFN,
                      controller: _messageController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xff333d79),
                      size: 30,
                    ),
                    onPressed: send,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  send() {
    _messageFN.unfocus();
    if (_messageController.text.isNotEmpty) {
      _chatController.sendMessage(message: _messageController.text.trim());
      _messageController.text = '';
    }
  }
}

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
    required this.chat,
  }) : super(key: key);

  final ChatMessage chat;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Moment.fromDateTime(chat.ts.toDate())
              .format('MMMM dd, yyyy hh:mm aa'),
          style: const TextStyle(
            fontSize: 10,
            color: Colors.blueGrey,
          ),
        ),
        Row(
          children: [
            if (chat.sentBy == FirebaseAuth.instance.currentUser!.uid)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
              ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment:
                          chat.sentBy != FirebaseAuth.instance.currentUser!.uid
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                      children: [
                          if (chat.sentBy !=
                            FirebaseAuth.instance.currentUser?.uid)
                          AvatarImage(uid: chat.sentBy, radius: 12,),
                           if (chat.sentBy ==
                            FirebaseAuth.instance.currentUser?.uid)
                          AvatarImage(uid: chat.sentBy, radius: 12,),
                        if (chat.sentBy !=
                            FirebaseAuth.instance.currentUser?.uid)
                          const SizedBox(
                            width: 8,
                          ),
                        if (chat.sentBy ==
                            FirebaseAuth.instance.currentUser?.uid)
                          const Text('You')
                        else
                          UserNameFromDB(uid: chat.sentBy),
                      
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(8),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                          color: Colors.black.withOpacity(0.1), width: 1.5),
                      color:
                          chat.sentBy == FirebaseAuth.instance.currentUser!.uid
                              ? const Color(0xff333d79)
                              : const Color.fromARGB(255, 68, 66, 66),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          chat.sentBy == FirebaseAuth.instance.currentUser!.uid
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.message,
                          style: const TextStyle(color: Colors.white),
                        ),
                        if (chat.sentBy !=
                            FirebaseAuth.instance.currentUser!.uid)
                          const SizedBox(height: 8),
                        if (chat.sentBy ==
                                FirebaseAuth.instance.currentUser!.uid &&
                            chat.message != 'message deleted')
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                                mainAxisAlignment: chat.sentBy ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (dCon) {
                                            return ChatEditingDialog(
                                                chat: chat);
                                          });
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      chat.deleteMessage();
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ]),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (chat.sentBy != FirebaseAuth.instance.currentUser!.uid)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment:
                chat.sentBy == FirebaseAuth.instance.currentUser!.uid
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              const Text(
                'Seen by ',
                style: TextStyle(fontSize: 10),
              ),
              for (int i = 0; i < chat.seenBy.length; i++)
                if (chat.seenBy[i] == FirebaseAuth.instance.currentUser!.uid)
                  Text(
                    'You${i != chat.seenBy.length - 1 ? ', ' : ''}',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  )
                else
                  FutureBuilder(
                      future: ChatUser.fromUid(uid: chat.seenBy[i]),
                      builder: (context, AsyncSnapshot<ChatUser> snap) {
                        if (snap.hasData) {
                          return Text(
                            '${snap.data?.username}${i != chat.seenBy.length - 1 ? ', ' : ''}',
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const Text('');
                      }),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatEditingDialog extends StatefulWidget {
  final ChatMessage chat;
  const ChatEditingDialog({required this.chat, Key? key}) : super(key: key);

  @override
  State<ChatEditingDialog> createState() => _ChatEditingDialogState();
}

class _ChatEditingDialogState extends State<ChatEditingDialog> {
  late TextEditingController tCon;
  @override
  initState() {
    tCon = TextEditingController(text: widget.chat.message);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Edit Message'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLines: 5,
                    onFieldSubmitted: (String text) {
                      widget.chat.updateMessage('[edited message] $text');
                      Navigator.of(context).pop();
                    },
                    controller: tCon,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color(0xff333d79),
                    size: 30,
                  ),
                  onPressed: () {
                    widget.chat.updateMessage('[edited message] ${tCon.text}');
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
