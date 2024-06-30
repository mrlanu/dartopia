import 'package:dartopia/messages/messages.dart';
import 'package:dartopia/messages/view/new_message_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MessagesView();
  }
}

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: MessagesTabsBar(),
              ),
              const SizedBox(
                height: 30,
              ),
              switch (state.selectedTab) {
                MessagesTabs.inbox =>
                  state.messagesStatus == MessagesStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : const MessagesTable(),
                MessagesTabs.sent =>
                  state.messagesStatus == MessagesStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : const MessagesTable(),
                MessagesTabs.write =>
                  state.sendingStatus == SendingStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : const MessageForm(),
              },
              //const Spacer(),
              const SizedBox(
                height: 15,
              ),
              state.selectedTab != MessagesTabs.write
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.only(right: 18.0),
                                child: ButtonsBar(),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          state.messagesResponse != null &&
                                  state
                                      .messagesResponse!.messagesList.isNotEmpty
                              ? const MessagesPaginator()
                              : const SizedBox(),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
