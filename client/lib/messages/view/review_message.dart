import 'package:dartopia/messages/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';

class ReviewMessage extends StatelessWidget {
  const ReviewMessage({super.key, required this.messageId});

  final String messageId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.75,
        ),
        child: FutureBuilder<MessageResponse>(
          future: context
              .read<MessagesRepository>()
              .fetchMessageById(messageId: messageId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final message = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From: ${message.senderName}',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${DateFormat('M/d/yyyy HH:mm:ss').format(message.dateTime)}',
                    style: textTheme.bodyMedium,
                  ),
                  const Divider(height: 24),
                  Text(
                    message.body,
                    style: textTheme.bodyLarge,
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton.outlined(
                        color: Colors.green,
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                      ),
                      IconButton.outlined(
                        color: Colors.green,
                        onPressed: () {
                          context.read<MessagesCubit>().reply(message: message);
                          context.pop();
                        },
                        icon: const Icon(Icons.reply),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
