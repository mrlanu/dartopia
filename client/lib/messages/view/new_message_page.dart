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

class MessageForm extends StatelessWidget {
  const MessageForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessagesCubit, MessagesState>(
      listenWhen: (previous, current) =>
          previous.sendingStatus != current.sendingStatus,
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
          context.read<MessagesCubit>().resetSendingStatus();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<MessagesCubit, MessagesState>(
          builder: (context, state) {
            return Column(
              children: [
                TextFormField(
                  initialValue: state.recipient,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Recipient',
                    //hintText: 'Enter your message here',
                  ),
                  onChanged: (value) =>
                      context.read<MessagesCubit>().recipientChanged(value),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: state.subject,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Subject',
                    //hintText: 'Enter your message here',
                  ),
                  onChanged: (value) =>
                      context.read<MessagesCubit>().subjectChanged(value),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: state.message,
                  minLines: 10,
                  maxLines: null,
                  // Allows for unlimited lines
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    //labelText: 'Message Body',
                    //hintText: 'Enter your message here',
                  ),
                  onChanged: (value) =>
                      context.read<MessagesCubit>().messageChanged(value),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _sendMessage(context,
                      recipient: state.recipient!,
                      subject: state.subject!,
                      message: state.message!),
                  child: Text(
                    'Send',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context,
      {required String recipient,
      required String subject,
      required String message}) {
    final request = MessageSendRequest(
      recipientName: recipient,
      subject: subject,
      body: message,
    );
    context.read<MessagesCubit>().sendMessage(request: request);
    // _clearControllers();
  }

/*void _clearControllers() {
    _controllerSubject.clear();
    _controllerRecipient.clear();
    _controllerMessage.clear();
  }*/
}
