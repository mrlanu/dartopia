import 'package:dartopia/messages/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../consts/colors.dart';

class MessagesTable extends StatelessWidget {
  const MessagesTable({super.key});

  static const _columnWidths = <int, TableColumnWidth>{
    0: FixedColumnWidth(36),
    1: FixedColumnWidth(36),
    2: FlexColumnWidth(1.4),
    3: FlexColumnWidth(2.2),
    4: FlexColumnWidth(1.4),
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        final isSent = state.selectedTab == MessagesTabs.sent;
        final messages = state.messagesResponse?.messagesList ?? [];

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Table(
                    columnWidths: _columnWidths,
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      _buildHeader(
                        context,
                        ['', '', isSent ? 'To' : 'From', 'Subject', 'Time'],
                        state.allChecked,
                      ),
                      for (final entry in messages.asMap().entries)
                        _buildDataRow(
                          context,
                          messageId: entry.value.id,
                          data: [
                            'check',
                            entry.value.read.toString(),
                            isSent
                                ? entry.value.recipientName
                                : entry.value.senderName,
                            entry.value.subject,
                            DateFormat('M/d HH:mm').format(entry.value.time),
                          ],
                          messageIndex: entry.key,
                          checkedList: state.checkedList,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  TableRow _buildHeader(
    BuildContext context,
    List<String> data,
    bool allChecked,
  ) {
    final headerStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(color: Colors.white, fontWeight: FontWeight.w600);

    return TableRow(
      decoration: const BoxDecoration(color: DartopiaColors.primary),
      children: [
        for (var index = 0; index < data.length; index++)
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
              child: index == 0
                  ? Checkbox(
                      side: const BorderSide(color: Colors.white, width: 2),
                      checkColor: Colors.white,
                      value: allChecked,
                      onChanged: (value) {
                        context
                            .read<MessagesCubit>()
                            .switchAllChecked(value ?? false);
                      },
                    )
                  : Text(
                      data[index],
                      style: headerStyle,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
            ),
          ),
      ],
    );
  }

  TableRow _buildDataRow(
    BuildContext context, {
    required String messageId,
    required List<String> data,
    required int messageIndex,
    required List<bool> checkedList,
  }) {
    final cellStyle = Theme.of(context).textTheme.bodySmall;

    return TableRow(
      decoration: const BoxDecoration(
        color: DartopiaColors.primaryContainer,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
      ),
      children: [
        for (var index = 0; index < data.length; index++)
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: switch (index) {
                0 => Checkbox(
                    value: checkedList[messageIndex],
                    onChanged: (value) {
                      context
                          .read<MessagesCubit>()
                          .switchCheck(messageIndex, value ?? false);
                    },
                  ),
                1 => FaIcon(
                    data[index] == 'true'
                        ? FontAwesomeIcons.envelopeOpen
                        : FontAwesomeIcons.envelope,
                    size: 16,
                  ),
                _ => GestureDetector(
                    onTap: () {
                      context.read<MessagesCubit>().decrementAmount();
                      context.push('/messages/$messageId');
                    },
                    child: Text(
                      data[index],
                      style: cellStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
              },
            ),
          ),
      ],
    );
  }
}
