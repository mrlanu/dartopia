part of 'world_bloc.dart';

sealed class WorldEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class CenterRequested extends WorldEvent {
  CenterRequested();
}

final class XIncremented extends WorldEvent {
  XIncremented();
}
final class YIncremented extends WorldEvent {
  YIncremented();
}
final class XDecremented extends WorldEvent {
  XDecremented();
}
final class YDecremented extends WorldEvent {
  YDecremented();
}

final class WorldFetched extends WorldEvent {
  WorldFetched();
}
