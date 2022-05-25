import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rocha_chatapp/service_locators.dart';
import 'package:rocha_chatapp/src/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:rocha_chatapp/src/controllers/chat_controller.dart';
import 'package:rocha_chatapp/src/models/chat_message_model.dart';
import 'package:rocha_chatapp/src/models/chat_user_model.dart';

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
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xff333d79),
        title: Row(
          children: [
            const Icon(Icons.message_outlined),
            const SizedBox(
              width: 6,
            ),
            Text('Chatting from ${user?.username ?? '...'}',
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                )),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                _auth.logout();
              },
              icon: const Icon(Icons.logout))
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
                    ),
                    onPressed: send,
                  )
                ],
              ),
            )
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
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      width: 500,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: chat.sentBy == FirebaseAuth.instance.currentUser?.uid
            ? const Color.fromARGB(255, 100, 120, 233)
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              color: chat.sentBy == FirebaseAuth.instance.currentUser?.uid
                  ? const Color.fromARGB(255, 100, 120, 233)
                  : Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FutureBuilder<ChatUser>(
                      future: ChatUser.fromUid(uid: chat.sentBy),
                      builder: (context, AsyncSnapshot<ChatUser> snap) {
                        if (snap.hasData) {
                          return Text(
                            chat.sentBy ==
                                    FirebaseAuth.instance.currentUser?.uid
                                ? 'You:'
                                : '${snap.data?.username}:',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          );
                        }
                        return const Text('User');
                      }),

                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      chat.message,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        chat.formatDate(chat.ts.toDate()),
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  )
                  // Text(
                  //     'Message seen by ${chat.seenBy}')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
