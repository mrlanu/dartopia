part of 'navigation_cubit.dart';

enum NavTab { buildings, map }

final class NavigationState extends Equatable {
  const NavigationState({
    this.tab = NavTab.buildings,
  });

  final NavTab tab;

  @override
  List<Object> get props => [tab];
}
