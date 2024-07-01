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
    final amount = await _messagesRepository.countNewMessages();
    emit(state.copyWith(
        checkedList: checkedList,
        messagesResponse: result,
        newMessagesAmount: amount,
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

  Future<void> reply({required MessageResponse message}) async {
    emit(state.copyWith(
        recipient: () => message.senderName,
        subject: () => 'Re: ${message.subject}',
        message: () => '${message.body}\n----------------------\n\n',
        selectedTab: MessagesTabs.write));
  }

  Future<void> recipientChanged(String value) async {
    emit(state.copyWith(recipient: () => value));
  }

  Future<void> subjectChanged(String value) async {
    emit(state.copyWith(subject: () => value));
  }

  Future<void> messageChanged(String value) async {
    emit(state.copyWith(message: () => value));
  }

  Future<void> resetForm() async {
    emit(state.copyWith(
      recipient: () => null,
      subject: () => null,
      message: () => null,
    ));
  }

  Future<void> decrementAmount() async {
    final amount = state.newMessagesAmount - 1;
    if(amount >= 0)emit(state.copyWith(newMessagesAmount: amount));
  }

  Future<void> resetSendingStatus() async {
    emit(state.copyWith(sendingStatus: SendingStatus.undefined));
  }
}
