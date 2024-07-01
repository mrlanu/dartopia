import 'package:dartopia/messages/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ReviewMessage extends StatelessWidget {
  const ReviewMessage({super.key, required this.messageId});

  final String messageId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding:
            const EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 50),
        child: FutureBuilder(
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From: ${snapshot.data!.senderName}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Date: ${DateFormat('M/d/yyyy HH:mm:ss').format(snapshot.data!.dateTime)}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Divider(),
                        Expanded(
                            child: SingleChildScrollView(
                                child: Text(
                          snapshot.data!.body,
                          style: Theme.of(context).textTheme.titleLarge,
                        ))),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton.outlined(
                                  color: Colors.green,
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete)),
                              IconButton.outlined(
                                  color: Colors.green,
                                  onPressed: () {
                                    context
                                        .read<MessagesCubit>()
                                        .reply(message: snapshot.data!);
                                    context.pop();
                                  },
                                  icon: const Icon(Icons.reply)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          },
          future: context
              .read<MessagesRepository>()
              .fetchMessageById(messageId: messageId),
        ));
  }
}
