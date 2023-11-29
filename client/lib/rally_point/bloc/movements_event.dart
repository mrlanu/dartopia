part of 'movements_bloc.dart';

sealed class MovementsEvent extends Equatable {
  const MovementsEvent();
}

final class MovementsSubscriptionRequested extends MovementsEvent {
  const MovementsSubscriptionRequested();

  @override
  List<Object?> get props => [];
}

final class MovementsFetchRequested extends MovementsEvent {
  const MovementsFetchRequested({required this.settlementId});

  final String settlementId;
  
  @override
  List<Object?> get props => [settlementId];
}
