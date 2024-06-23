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

class MessagesState extends Equatable {
  const MessagesState(
      {this.page,
      this.selectedTab = MessagesTabs.inbox,
      this.messagesResponse,
      this.messagesStatus = MessagesStatus.loading});

  final int? page;
  final MessagesTabs selectedTab;
  final MessagesResponse? messagesResponse;
  final MessagesStatus messagesStatus;

  MessagesState copyWith({
    int? page,
    MessagesTabs? selectedTab,
    MessagesResponse? messagesResponse,
    MessagesStatus? messagesStatus,
  }) {
    return MessagesState(
      page: page ?? this.page,
      selectedTab: selectedTab ?? this.selectedTab,
      messagesResponse: messagesResponse ?? this.messagesResponse,
      messagesStatus: messagesStatus ?? this.messagesStatus,
    );
  }

  @override
  List<Object?> get props =>
      [page, selectedTab, messagesResponse, messagesStatus];
}
