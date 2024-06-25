import 'package:dartopia/messages/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../consts/colors.dart';

class MessagesTabsBar extends StatelessWidget {
  const MessagesTabsBar({super.key});

  static const double fontSize = 30;

  @override
  Widget build(BuildContext context) {
    final selected =
        context.select((MessagesCubit cubit) => cubit.state.selectedTab);
    const selectedColor = DartopiaColors.primary;
    return Wrap(
      spacing: 3,
      children: [
        ChoiceChip(
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.zero,
          selectedColor: selectedColor,
          checkmarkColor: Colors.white,
          label: Text(
            'Inbox',
            style: TextStyle(
                color: selected.index == 0 ? Colors.white : Colors.black,
                fontSize: fontSize),
          ),
          selected: selected.index == 0,
          onSelected: (value) {
            value
                ? context
                    .read<MessagesCubit>()
                    .changeSelectedTab(MessagesTabs.values[0])
                : null;
            context.read<MessagesCubit>().fetchMessages(sent: false);
          },
        ),
        ChoiceChip(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.transparent),
          ),
          padding: EdgeInsets.zero,
          selectedColor: selectedColor,
          checkmarkColor: Colors.white,
          label: Text(
            'Sent',
            style: TextStyle(
                color: selected.index == 1 ? Colors.white : Colors.black,
                fontSize: fontSize),
          ),
          selected: selected.index == 1,
          onSelected: (value) {
            value
                ? context
                    .read<MessagesCubit>()
                    .changeSelectedTab(MessagesTabs.values[1])
                : null;
            context.read<MessagesCubit>().fetchMessages(sent: true);
          },
        ),
        ChoiceChip(
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.zero,
          selectedColor: selectedColor,
          checkmarkColor: Colors.white,
          label: Text(
            'Write',
            style: TextStyle(
                color: selected.index == 2 ? Colors.white : Colors.black,
                fontSize: fontSize),
          ),
          selected: selected.index == 2,
          onSelected: (value) {
            value
                ? context
                    .read<MessagesCubit>()
                    .changeSelectedTab(MessagesTabs.values[2])
                : null;
          },
        ),
      ],
    );
  }
}
