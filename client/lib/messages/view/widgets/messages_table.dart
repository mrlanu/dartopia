import 'package:dartopia/messages/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';

import '../../../consts/colors.dart';

class MessagesTable extends StatelessWidget {
  const MessagesTable({super.key, required this.messages});

  final List<MessagesModel> messages;

  @override
  Widget build(BuildContext context) {
    final sent = context
        .read<MessagesCubit>()
        .state
        .selectedTab;
    return Table(
        columnWidths: const {
          0: FixedColumnWidth(30.0),
          1: FixedColumnWidth(100.0),
          2: FixedColumnWidth(150.0),
        },
        children: sent == MessagesTabs.sent ? [
          _buildHeader(['', 'To', 'Subject', 'Time'], context),
          ...messages.map((m) =>
              _buildDataRow([
                m.read.toString(),
                m.recipientName,
                m.subject,
                DateFormat('M/d HH:mm:ss').format(m.time),
              ], context)).toList()
        ] : [
          _buildHeader(['', 'From', 'Subject', 'Time'], context),
          ...messages.map((m) =>
              _buildDataRow([
                m.read.toString(),
                m.senderName,
                m.subject,
                DateFormat('M/d HH:mm:ss').format(m.time),
              ], context)).toList()
        ]
    );
  }

  TableRow _buildHeader(List<String> data, BuildContext context) {
    return TableRow(
      decoration: const BoxDecoration(color: DartopiaColors.primary),
      children: [
        ...List.generate(
          data.length,
              (index) =>
              TableCell(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
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
        )
      ],
    );
  }

  TableRow _buildDataRow(List<String> data, BuildContext context) {
    return TableRow(
      decoration: const BoxDecoration(
        color: DartopiaColors.primaryContainer,
        border:
        Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
      ),
      children: [
        ...List.generate(
          data.length,
              (index) =>
              TableCell(
                child: GestureDetector(
                  onTap: () => print(data[1]),
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: index == 0 ? Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: FaIcon(data[index] == 'true'
                              ? FontAwesomeIcons.envelopeOpen
                              : FontAwesomeIcons.envelope),
                        ) : Text(
                            data[index],
                            overflow: TextOverflow.ellipsis,
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleMedium!
                        ),
                      )),
                ),
              ),
        ),
      ],
    );
  }
}
