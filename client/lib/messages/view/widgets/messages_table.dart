import 'package:dartopia/messages/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../consts/colors.dart';

class MessagesTable extends StatelessWidget {
  const MessagesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        return Table(
            columnWidths: const {
              0: FixedColumnWidth(30.0),
              1: FixedColumnWidth(30.0),
              2: FixedColumnWidth(75.0),
              3: FixedColumnWidth(150.0),
            },
            children: state.selectedTab == MessagesTabs.sent
                ? [
              _buildHeader(['', '', 'To', 'Subject', 'Time'],
                  state.allChecked, context),
              ...state.messagesResponse!
                  .messagesList
                  .asMap()
                  .entries
                  .map((entry) {
                int index = entry.key;
                var m = entry.value;
                return _buildDataRow(messageId: m.id,
                    data: [
                      'check',
                      m.read.toString(),
                      m.recipientName,
                      m.subject,
                      DateFormat('M/d HH:mm:ss').format(m.time),
                    ],
                    messageIndex: index,
                    checkedList: state.checkedList,
                    context);
              }).toList()
            ]
                : [
              _buildHeader(['', '', 'From', 'Subject', 'Time'],
                  state.allChecked, context),
              ...state.messagesResponse!
                  .messagesList
                  .asMap()
                  .entries
                  .map((entry) {
                int index = entry.key;
                var m = entry.value;
                return _buildDataRow(messageId: m.id,
                    data: [
                      'check',
                      m.read.toString(),
                      m.senderName,
                      m.subject,
                      DateFormat('M/d HH:mm:ss').format(m.time),
                    ],
                    messageIndex: index,
                    checkedList: state.checkedList,
                    context);
              }).toList()
            ]);
      },
    );
  }

  TableRow _buildHeader(List<String> data, bool allChecked,
      BuildContext context) {
    return TableRow(
      decoration: const BoxDecoration(color: DartopiaColors.primary),
      children: [
        ...List.generate(
          data.length,
              (index) =>
              TableCell(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: index == 0
                        ? Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Checkbox(
                        side: const BorderSide(color: Colors.white, width: 2),
                        checkColor: Colors.white,
                        value: allChecked,
                        onChanged: (value) {
                          context
                              .read<MessagesCubit>()
                              .switchAllChecked(value!);
                        },
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        data[index],
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
        )
      ],
    );
  }

  TableRow _buildDataRow(BuildContext context,
      {required String messageId, required List<String> data,
        required int messageIndex, required List<bool> checkedList}) {
    return TableRow(
      decoration: const BoxDecoration(
        color: DartopiaColors.primaryContainer,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
      ),
      children: [
        ...List.generate(
          data.length,
              (index) =>
              TableCell(
                child: Center(
                    child: switch (index) {
                      0 =>
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Checkbox(
                              checkColor: Colors.white,
                              value: checkedList[messageIndex],
                              onChanged: (value) {
                                context
                                    .read<MessagesCubit>()
                                    .switchCheck(messageIndex, value!);
                              },
                            ),
                          ),
                      1 =>
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 12),
                            child: FaIcon(data[index] == 'true'
                                ? FontAwesomeIcons.envelopeOpen
                                : FontAwesomeIcons.envelope),
                          ),
                      _ =>
                          GestureDetector(
                            onTap: () {
                              context.read<MessagesCubit>().decrementAmount();
                              context.push('/messages/$messageId');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 11.0),
                              child: Text(data[index],
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium!),
                            ),
                          ),
                    }),
              ),
        ),
      ],
    );
  }
}
