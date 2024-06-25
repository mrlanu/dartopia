import 'package:dartopia/messages/messages.dart';
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
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: MessagesTabsBar(),
        ),
        BlocBuilder<MessagesCubit, MessagesState>(
          builder: (context, state) {
            return switch(state.selectedTab){
              MessagesTabs.inbox => state.messagesStatus == MessagesStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : MessagesTable(messages: state.messagesResponse!.messagesList),
              MessagesTabs.sent => state.messagesStatus == MessagesStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : MessagesTable(messages: state.messagesResponse!.messagesList),
              MessagesTabs.write => const SizedBox(),
            };
          },
        ),
        const Spacer(),
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: MessagesPaginator(),
        ),
      ],
    );
  }
}

