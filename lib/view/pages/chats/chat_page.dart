import 'package:bagisla/model/message/message.dart';
import 'package:bagisla/model/user/user_model.dart';
import 'package:bagisla/service/db/local_db_service.dart';
import 'package:bagisla/util/human_readable_date.dart';
import 'package:bagisla/view/colors/app_colors.dart';
import 'package:bagisla/view/components/custom_alert_dialogs.dart';
import 'package:bagisla/view/components/view_state.dart';
import 'package:bagisla/view/pages/loading/loading_page.dart';
import 'package:bagisla/viewmodel/chat/chat_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.chattedUserUid, this.lastMessage}) : super(key: key);
  final String chattedUserUid;
  final String? lastMessage;

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final ChatPageViewModel _chatPageViewModel = ChatPageViewModel();
  final ScrollController _scrollController = ScrollController();
  final LocalDBService _localDBService = LocalDBService();
  bool _isLoading = false;

  UserModel? _chattedUser;

  @override
  void initState() {
    super.initState();
    _getUser();
    _scrollController.addListener(_scrollListener);
  }

  _getUser() async {
    _chattedUser = await _chatPageViewModel.getUser(widget.chattedUserUid);
    _chattedUser == null
        ? await customAlertDialogError(context, "HATA!", "Kullanıcı bulunamadı hesap silinmiş olabilir!")
        : _updateSeen();
  }

  _updateSeen() async {
    _chatPageViewModel.updateSeen(_chattedUser!.uid!);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => _chatPageViewModel.getViewState == ViewState.idle
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.appBarColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.greyColor,
                      backgroundImage: NetworkImage(_chattedUser!.photoUrl!),
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Expanded(
                      child: Text(
                        "${_chattedUser!.name} ${_chattedUser!.surname}",
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  buildMessageList(size),
                  chatControls(size),
                ],
              ),
            )
          : const LoadingPage(),
    );
  }

  Widget buildMessageList(Size size) {
    return StreamBuilder<List<Message>>(
        stream: _chatPageViewModel.bringOldMessages(
          widget.chattedUserUid,
          widget.lastMessage,
        ),
        builder: (context, AsyncSnapshot<List<Message>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Expanded(
                child: Center(
                  child: Text(
                    "Mesajlaşmaya başlayın",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {});

              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _createSpeechBubble(snapshot.data![index]);
                  },
                ),
              );
            }
          }
          return const Expanded(child: SizedBox());
        });
  }

  Widget chatControls(Size size) {
    return Container(
      color: AppColors.appBarColor,
      height: size.height * 0.07,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              cursorColor: Colors.white,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                fillColor: AppColors.appBarColor,
                filled: true,
                hintText: "Mesajınız",
                hintStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              child: const Icon(
                Icons.send,
                size: 30,
                color: Colors.white,
              ),
              onTap: () async {
                if (_messageController.text.trim().isNotEmpty) {
                  Message saveMessage = Message(
                    fromWho: _localDBService.readUserFromLocalDB()!.uid!,
                    who: _chattedUser!.uid!,
                    fromMe: true,
                    message: _messageController.text,
                    chattedUserName: "${_chattedUser!.name} ${_chattedUser!.surname[0]}",
                    chattedUserProfileUrl: _chattedUser!.photoUrl!,
                  );
                  bool result = await _chatPageViewModel.saveMessage(saveMessage);
                  if (result) {
                    _messageController.clear();
                    _scrollController.animateTo(
                      0.0,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeOut,
                    );
                  }
                } else {
                  await Get.snackbar("Eksik Bilgi", "Mesaj giriniz").show();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createSpeechBubble(Message message) {
    var fromMe = message.fromMe;
    if (fromMe) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: message.fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.appBarColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              message.message,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                humanReadableTime(message.date!),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(_chattedUser!.photoUrl!),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: message.fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppColors.appBarColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                message.message,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  humanReadableTime(message.date!),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      bringOldMessages();
    }
  }

  void bringOldMessages() async {
    if (_isLoading == false) {
      _isLoading = true;
      // await _chatModel.bringOldMessages();
      _isLoading = false;
    }
  }
}
