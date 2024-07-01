part of 'messages_cubit.dart';

enum MessagesStatus {
  loading,
  success,
  failure,
}

enum MessagesTabs {
  inbox,
  sent,
  write,
}

enum SendingStatus {
  undefined,
  loading,
  success,
  failure,
}

class MessagesState extends Equatable {
  const MessagesState({
    this.recipient,
    this.subject,
    this.message,
    this.newMessagesAmount = 0,
    this.page,
    this.selectedTab = MessagesTabs.inbox,
    this.messagesResponse,
    this.messagesStatus = MessagesStatus.loading,
    this.sendingStatus = SendingStatus.undefined,
    this.checkedList = const [],
    this.errorMessage = '',
  });

  final String? recipient;
  final String? subject;
  final String? message;
  final int newMessagesAmount;
  final int? page;
  final MessagesTabs selectedTab;
  final MessagesResponse? messagesResponse;
  final MessagesStatus messagesStatus;
  final SendingStatus sendingStatus;
  final List<bool> checkedList;
  final String errorMessage;

  bool get allChecked => !checkedList.contains(false);

  bool get anyChecked => checkedList.contains(true);

  MessagesState copyWith({
    String? Function()? recipient,
    String? Function()? subject,
    String? Function()? message,
    int? newMessagesAmount,
    int? page,
    MessagesTabs? selectedTab,
    MessagesResponse? messagesResponse,
    MessagesStatus? messagesStatus,
    SendingStatus? sendingStatus,
    List<bool>? checkedList,
    String? errorMessage,
  }) {
    return MessagesState(
      recipient: recipient != null ? recipient() : this.recipient,
      subject: subject != null ? subject() : this.subject,
      message: message != null ? message() : this.message,
      newMessagesAmount: newMessagesAmount ?? this.newMessagesAmount,
      page: page ?? this.page,
      selectedTab: selectedTab ?? this.selectedTab,
      messagesResponse: messagesResponse ?? this.messagesResponse,
      messagesStatus: messagesStatus ?? this.messagesStatus,
      sendingStatus: sendingStatus ?? this.sendingStatus,
      checkedList: checkedList ?? this.checkedList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        recipient,
        subject,
        message,
        newMessagesAmount,
        page,
        selectedTab,
        messagesResponse,
        messagesStatus,
        sendingStatus,
        checkedList,
        errorMessage,
      ];
}
