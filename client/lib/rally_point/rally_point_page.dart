import 'package:dartopia/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'rally_point.dart';

class RallyPointPage extends StatelessWidget {
  const RallyPointPage({super.key, required this.buildingRecord});

  final List<int> buildingRecord;

  static Route<void> route(
      {required List<int> buildingRecord, required MovementsBloc movementsBloc}) {
    return MaterialPageRoute(builder: (context) {
      return MultiBlocProvider(
        providers: [
          /*BlocProvider(
            create: (context) => TransactionBloc(
              transactionsRepository:
              context.read<TransactionsRepositoryImpl>(),
              categoriesRepository: context.read<CategoriesRepositoryImpl>(),
              subcategoriesRepository:
              context.read<SubcategoriesRepositoryImpl>(),
              accountsRepository: context.read<AccountsRepositoryImpl>(),
            )..add(TransactionFormLoaded(
                transaction: transaction,
                transactionType: transactionType,
                date: date)),
          ),*/
          BlocProvider.value(value: movementsBloc),
        ],
        child: RallyPointPage(buildingRecord: buildingRecord),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return RallyPointView(buildingRecord: buildingRecord);
  }
}

class RallyPointView extends StatelessWidget {
  const RallyPointView({super.key, required this.buildingRecord});

  final List<int> buildingRecord;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(),
        body: BlocBuilder<MovementsBloc, MovementsState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  state.movements[MovementLocation.incoming]!.isNotEmpty ?
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Incoming troops (${state.movements[MovementLocation
                          .incoming]!.length})',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium,
                    ),
                  ) : Container(),
                  ...state.movements[MovementLocation.incoming]!
                      .map((move) =>
                      TroopDetails(
                        movement: move,
                      ))
                      .toList(),
                  state.movements[MovementLocation.outgoing]!.isNotEmpty ?
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Outgoing troops (${state.movements[MovementLocation
                          .outgoing]!.length})',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium,
                    ),
                  ) : Container(),
                  ...state.movements[MovementLocation.outgoing]!
                      .map((move) =>
                      TroopDetails(
                        movement: move,
                      ))
                      .toList(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Troops in this village and its oases (${state
                          .movements[MovementLocation.home]!.length})',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium,
                    ),
                  ),
                  ...state.movements[MovementLocation.home]!
                      .map((move) =>
                      TroopDetails(
                        movement: move,
                      ))
                      .toList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
