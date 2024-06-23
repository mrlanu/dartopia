import 'package:dartopia/messages/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../../consts/colors.dart';

class MessagesTable extends StatelessWidget {
  const MessagesTable({super.key, required this.messages});

  final List<MessagesModel> messages;

  @override
  Widget build(BuildContext context) {
    final filter =
        context.select((MessagesCubit cubit) => cubit.state.selectedTab);
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(40.0),
        1: FixedColumnWidth(110.0),
        2: FixedColumnWidth(110.0),
        3: FixedColumnWidth(70.0),
      },
      children: [
        _buildHeader(['', 'Player', 'Alliance', 'Populations', 'Villages']),
        ...messages.map((m) => _buildDataRow([
          m.subject,
          m.recipientName,
          m.time.toString(),])).toList()
      ]
    );
  }

  TableRow _buildHeader(List<String> data) {
    return TableRow(
      decoration: const BoxDecoration(color: DartopiaColors.primary),
      children: [
        ...List.generate(
          data.length,
          (index) => TableCell(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  data[index],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  TableRow _buildDataRow(List<String> data) {
    return TableRow(
      decoration: const BoxDecoration(
        color: DartopiaColors.primaryContainer,
        border:
            Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
      ),
      children: [
        ...List.generate(
          data.length,
          (index) => TableCell(
            child: GestureDetector(
              onTap: () => print(data[1]),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  data[index],
                  overflow: TextOverflow.ellipsis,
                ),
              )),
            ),
          ),
        ),
      ],
    );
  }
}
