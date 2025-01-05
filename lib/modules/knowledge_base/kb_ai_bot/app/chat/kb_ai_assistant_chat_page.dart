import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/gen/assets.gen.dart';
import 'package:jarvis_ai/locator.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/chat/kb_ai_assistant_chat_page_viewmodel.dart';
import 'package:jarvis_ai/modules/knowledge_base/kb_ai_bot/app/chat/setting/kb_ai_assistant_setting_page.dart';
import 'package:jarvis_ai/modules/shared/widgets/start_an_conversation_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:suga_core/suga_core.dart';

class KBAIAssistantChatPage extends StatefulWidget {
  final String assistantId;

  const KBAIAssistantChatPage({super.key, required this.assistantId});

  @override
  State<KBAIAssistantChatPage> createState() => _KBAIAssistantChatPageState();
}

class _KBAIAssistantChatPageState extends BaseViewState<KBAIAssistantChatPage, KBAIAssistantChatPageViewModel> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  bool _showHint = false;

  @override
  loadArguments() {
    viewModel.assistantId = widget.assistantId;
  }

  void _sendMessage() {
    viewModel.askToAssistant(_textController.text);
    _textController.clear();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(viewModel.assistant?.assistantName ?? 'Assistant'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Get.to(() => KBAIAssistantSettingPage(assistantId: widget.assistantId), transition: Transition.downToUp);
                },
                icon: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF1677FF),
                ),
              ),
            ],
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          drawer: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              children: [
                DrawerHeader(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Assets.images.imgAssistant.image(
                      width: 100,
                      height: 100,
                    ),
                    const Text(
                      'History',
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                  ],
                )),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await viewModel.onRefreshThread();
                    },
                    child: Obx(
                      () => ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          ...viewModel.kBAIThreadList.map(
                            (item) => ListTile(
                              title: Text(
                                item.threadName,
                                style: TextStyle(
                                  color: viewModel.threadId == item.openAiThreadId ? Colors.blue : Colors.black,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                viewModel.threadId = item.openAiThreadId;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 10) {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
            child: Stack(
              children: [
                Column(
                  children: [
                    if (viewModel.isCreatingMessage)
                      Container(
                        width: double.infinity,
                        color: Colors.blue.withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Creating thread",
                              style: TextStyle(fontSize: 12, color: Colors.blue),
                            ),
                            const SizedBox(width: 8),
                            LoadingAnimationWidget.waveDots(
                              size: 20,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Obx(
                        () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollToBottom();
                          });

                          if (viewModel.messages.isEmpty && !viewModel.isCreatingMessage) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  StartAnConversationWidget(
                                    title: viewModel.threadId != null ? "Loading history" : "Start a conversation",
                                    subtitle: viewModel.threadId != null ? "" : "Send a message to start a conversation",
                                    icon: LoadingAnimationWidget.waveDots(
                                      size: 50.w,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: viewModel.messages.length + (viewModel.isAnswering ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == viewModel.messages.length && viewModel.isAnswering) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Answering...",
                                        style: TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: LoadingAnimationWidget.waveDots(
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              final message = viewModel.messages[index];
                              final isUserMessage = message.role == 'user';

                              return Align(
                                alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    if (!isUserMessage)
                                      const Text(
                                        "Assistant",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isUserMessage ? Colors.blue.shade100 : Colors.grey.shade200,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(16),
                                          topRight: const Radius.circular(16),
                                          bottomLeft: isUserMessage ? const Radius.circular(16) : Radius.zero,
                                          bottomRight: isUserMessage ? Radius.zero : const Radius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        message.content.first.text.value,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isUserMessage ? Colors.black : Colors.grey.shade800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              viewModel.threadId = null;
                            },
                            icon: const Icon(Icons.add),
                            color: Colors.blue,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              decoration: InputDecoration(
                                hintText: "Type a message...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _sendMessage,
                            icon: const Icon(Icons.send),
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  top: MediaQuery.of(context).size.height / 6,
                  child: GestureDetector(
                    onLongPress: () {
                      setState(() {
                        _showHint = true;
                      });
                    },
                    onLongPressUp: () {
                      setState(() {
                        _showHint = false;
                      });
                    },
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.5),
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedOpacity(
                          opacity: _showHint ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.8),
                              borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                            ),
                            child: const Text(
                              "Swipe to open drawer",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  KBAIAssistantChatPageViewModel createViewModel() {
    return locator<KBAIAssistantChatPageViewModel>();
  }
}
