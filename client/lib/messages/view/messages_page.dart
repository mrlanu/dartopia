import 'package:dartopia/messages/messages.dart';
import 'package:dartopia/messages/view/new_meddage_page.dart';
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
                      : MessagesTable(
                          messages: state.messagesResponse!.messagesList),
                MessagesTabs.sent =>
                  state.messagesStatus == MessagesStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : MessagesTable(
                          messages: state.messagesResponse!.messagesList),
                MessagesTabs.write =>
                  state.messagesStatus == MessagesStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : const NewMessage(),
              },
              //const Spacer(),
              const SizedBox(
                height: 30,
              ),
              state.selectedTab != MessagesTabs.write
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: MessagesPaginator(),
                    )
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
