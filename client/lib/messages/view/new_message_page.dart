import 'package:dartopia/messages/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class NewMessagePage extends StatelessWidget {
  const NewMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: MessageForm(),
    );
  }
}

class MessageForm extends StatefulWidget {
  const MessageForm({super.key});

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final TextEditingController _controllerSubject = TextEditingController();
  final TextEditingController _controllerRecipient = TextEditingController();
  final TextEditingController _controllerMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessagesCubit, MessagesState>(
      listenWhen: (previous, current) => previous.sendingStatus != current.sendingStatus,
      listener: (context, state) {
        if (state.sendingStatus == SendingStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerRecipient,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Recipient',
                //hintText: 'Enter your message here',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _controllerSubject,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Subject',
                //hintText: 'Enter your message here',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _controllerMessage,
              minLines: 10,
              maxLines: null,
              // Allows for unlimited lines
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                //labelText: 'Message Body',
                //hintText: 'Enter your message here',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text(
                'Send',
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final request = MessageSendRequest(
      recipientName: _controllerRecipient.text,
      subject: _controllerSubject.text,
      body: _controllerMessage.text,
    );
    context.read<MessagesCubit>().sendMessage(request: request);
   // _clearControllers();
  }

  void _clearControllers() {
    _controllerSubject.clear();
    _controllerRecipient.clear();
    _controllerMessage.clear();
  }
}
