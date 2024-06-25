import 'package:dartopia/messages/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';

class MessagesPaginator extends StatelessWidget {
  const MessagesPaginator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final messagesResponse =
        context.select((MessagesCubit bloc) => bloc.state.messagesResponse);
    final selectedTab =
        context.select((MessagesCubit bloc) => bloc.state.selectedTab);
    final totalPageInt =
        messagesResponse != null ? messagesResponse.totalPages : 2;
    final currentPage =
        messagesResponse != null ? messagesResponse.currentPage : 1;
    return NumberPaginator(
      key: UniqueKey(),
      config: NumberPaginatorUIConfig(
          buttonSelectedBackgroundColor: Colors.orange,
          buttonTextStyle: Theme.of(context).textTheme.displayLarge),
      numberPages: totalPageInt,
      initialPage: currentPage - 1,
      onPageChange: (int index) {
        context.read<MessagesCubit>().fetchMessages(
            page: (index + 1).toString(),
            sent: selectedTab == MessagesTabs.sent);
      },
    );
  }
}
