import 'package:bloc/bloc.dart';
import 'package:dartopia/messages/messages.dart';
import 'package:dartopia/messages/messages_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:network/network.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit({required MessagesRepository messagesRepository})
      : _messagesRepository = messagesRepository,
        super(const MessagesState());

  final MessagesRepository _messagesRepository;

  Future<void> sendMessage({required MessageSendRequest request}) async {
    try {
      await _messagesRepository.sendMessage(request: request);
      final response = await _messagesRepository.fetchMessages(sent: true);
      final checkedList = response.messagesList.map((e) => false).toList();
      emit(state.copyWith(
          sendingStatus: SendingStatus.success,
          messagesResponse: response,
          checkedList: checkedList,
          selectedTab: MessagesTabs.sent));
    } on NetworkException catch (e) {
      emit(state.copyWith(
          sendingStatus: SendingStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> fetchMessages({String? page, bool? sent}) async {
    emit(state.copyWith(messagesStatus: MessagesStatus.loading));
    final result = await _messagesRepository.fetchMessages(
        page: page, sent: sent ?? false);
    final checkedList = result.messagesList.map((e) => false).toList();
    emit(state.copyWith(
        checkedList: checkedList,
        messagesResponse: result,
        messagesStatus: MessagesStatus.success));
  }

  Future<void> countNewMessages() async {
    final amount = await _messagesRepository.countNewMessages();
    emit(state.copyWith(newMessagesAmount: amount));
  }

  Future<void> changeSelectedTab(MessagesTabs tab) async {
    emit(state.copyWith(selectedTab: tab));
  }

  Future<void> switchAllChecked(bool value) async {
    final newList = state.checkedList.map((e) => value).toList();
    emit(state.copyWith(checkedList: newList));
  }

  Future<void> switchCheck(int messageIndex, bool value) async {
    final newList = state.checkedList.map((e) => e).toList();
    newList[messageIndex] = value;
    emit(state.copyWith(checkedList: newList));
  }

  Future<void> deleteChecked() async {
    final List<String> checkedMessagesId = [];
    for (var i = 0; i < state.messagesResponse!.messagesList.length; i++) {
      if (state.checkedList[i] == true) {
        checkedMessagesId.add(state.messagesResponse!.messagesList[i].id);
      }
    }
    await _messagesRepository.delete(checkedMessagesId);
    fetchMessages(sent: state.selectedTab == MessagesTabs.sent);
  }

  Future<void> reply({required String messageId}) async {
    emit(state.copyWith(selectedTab: MessagesTabs.write));
  }
}
