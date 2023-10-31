part of 'village_bloc.dart';

sealed class VillageEvent extends Equatable {
  const VillageEvent();
}

final class VillageFetchRequested extends VillageEvent {
  final String villageId;

  const VillageFetchRequested({required this.villageId});

  @override
  List<Object?> get props => [villageId];
}


