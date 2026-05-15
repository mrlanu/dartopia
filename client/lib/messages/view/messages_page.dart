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
        return Column(
          children: [
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: MessagesTabsBar(),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: switch (state.selectedTab) {
                MessagesTabs.inbox ||
                MessagesTabs.sent =>
                  state.messagesStatus == MessagesStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : const MessagesTable(),
                MessagesTabs.write =>
                  state.sendingStatus == SendingStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : const SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: MessageForm(),
                        ),
              },
            ),
            if (state.selectedTab != MessagesTabs.write) ...[
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ButtonsBar(),
                ),
              ),
              const SizedBox(height: 4),
              if (state.messagesResponse != null &&
                  state.messagesResponse!.messagesList.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: MessagesPaginator(),
                ),
            ],
          ],
        );
      },
    );
  }
}
