import 'package:dartopia/messages/cubit/messages_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonsBar extends StatelessWidget {
  const ButtonsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final anyChecked =
    context.select((MessagesCubit bloc) => bloc.state.anyChecked);
    return Row(
      children: [
        IconButton.outlined(
            color: Colors.green,
            onPressed: anyChecked ? () {
              context.read<MessagesCubit>().deleteChecked();
            } : null,
            icon: const Icon(Icons.delete)),
        IconButton.outlined(
            color: Colors.green,
            onPressed: anyChecked ? () {
              //context.read<MessagesCubit>().markAsReadChecked();
            } : null,
            icon: const Icon(Icons.mark_email_read_outlined)),
      ],

    );
  }
}
