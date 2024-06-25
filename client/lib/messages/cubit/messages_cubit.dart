import 'package:bloc/bloc.dart';
import 'package:dartopia/messages/messages.dart';
import 'package:dartopia/messages/messages_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit({required MessagesRepository messagesRepository})
      : _messagesRepository = messagesRepository,
        super(const MessagesState());

  final MessagesRepository _messagesRepository;

  Future<void> fetchMessages({String? page}) async {
    /*emit(state.copyWith(messagesStatus: MessagesStatus.loading));
    final result = await _messagesRepository.fetchMessages(page: page);
    emit(state.copyWith(
        messagesResponse: result,
        messagesStatus: MessagesStatus.success));*/
  }

  Future<void> changeSelectedTab(MessagesTabs tab) async {
    emit(state.copyWith(selectedTab: tab));
  }
}