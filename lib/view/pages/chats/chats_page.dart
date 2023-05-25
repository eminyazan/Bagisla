import 'package:bagisla/model/message/speech.dart';
import 'package:bagisla/util/human_readable_date.dart';
import 'package:bagisla/view/colors/app_colors.dart';
import 'package:bagisla/view/components/custom_navigation.dart';
import 'package:bagisla/view/components/view_state.dart';
import 'package:bagisla/view/pages/chats/chat_page.dart';
import 'package:bagisla/view/pages/loading/loading_page.dart';
import 'package:bagisla/viewmodel/chat/chats_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final ChatsPageViewModel _chatsPageViewModel = ChatsPageViewModel();

  List<Speech>? _allConversations;

  @override
  void initState() {
    super.initState();
    _getAllConversations();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => _chatsPageViewModel.getViewState == ViewState.idle
          ? Scaffold(
              appBar: AppBar(
                title: const Text("Sohbetleriniz"),
              ),
              body: StreamBuilder<List<Speech>>(
                  stream: _chatsPageViewModel.getAllConversationsStream(),
                  builder: (context, snapshot) {
                    _allConversations = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingPage();
                    }
                    if (_allConversations == null || _allConversations!.isEmpty) {
                      return const Center(
                        child: Text(
                          "Hiç sohbetiniz bulunmuyor",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: _allConversations!.length,
                        reverse: false,
                          shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Theme(
                              data: ThemeData(
                                splashColor: AppColors.signInColor,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey.shade900),
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    goPage(
                                      context,
                                      ChatPage(
                                        chattedUserUid:
                                            _allConversations![index].chatWith,
                                        lastMessage: _allConversations![index]
                                            .lastMessage,
                                      ),
                                    );
                                  },
                                  title: Text(
                                    _allConversations![index].chattedUserName,
                                    style: const TextStyle(
                                      color: AppColors.appBarColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: (_allConversations![index]
                                              .lastMessage
                                              .length <
                                          28)
                                      ? Text(
                                          _allConversations![index].lastMessage,
                                          style: TextStyle(
                                            color: _allConversations![index].seen
                                                    ? AppColors.greyColor
                                                    : Colors.black,
                                            fontSize: 18,
                                            fontWeight:
                                                _allConversations![index].seen
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                          ),
                                        )
                                      : Text(
                                          "${_allConversations![index].lastMessage.substring(0, 23)}....",
                                          style: TextStyle(
                                            color:
                                                _allConversations![index].seen
                                                    ? AppColors.greyColor
                                                    : Colors.black,
                                            fontSize: 18,
                                            fontWeight:
                                                _allConversations![index].seen
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                          ),
                                        ),
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.greyColor,
                                    backgroundImage: NetworkImage(
                                      _allConversations![index]
                                          .chattedUserProfileUrl,
                                    ),
                                    radius: 30,
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Opacity(
                                        opacity: 0,
                                        child: Icon(
                                          Icons.notifications,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Text(
                                        humanReadableTime(
                                          _allConversations![index]
                                              .lastMessageDate,
                                        ),
                                        style: const TextStyle(
                                          color: AppColors.greyColor,
                                          fontSize: 17,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
            )
          : const LoadingPage(),
    );
  }

  void _getAllConversations() async {
    _allConversations = await _chatsPageViewModel.getAllConversations();
  }
}
