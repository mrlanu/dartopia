import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartopia/messages/messages.dart';
import 'package:dartopia/reports/reports.dart';
import 'package:equatable/equatable.dart';

import '../../consts/consts.dart';
import '../../settlement/repository/settlement_repository.dart';

part 'periodic_update_state.dart';

class PeriodicUpdateCubit extends Cubit<PeriodicUpdateState> {
  PeriodicUpdateCubit(
      {required SettlementRepository settlementRepository,
      required MessagesRepository messagesRepository,
      required ReportsRepository reportsRepository})
      : _villageRepository = settlementRepository,
        _reportsRepository = reportsRepository,
        _messagesRepository = messagesRepository,
        super(const PeriodicUpdateState());

  final SettlementRepository _villageRepository;
  final MessagesRepository _messagesRepository;
  final ReportsRepository _reportsRepository;
  Timer? _timer;

  void startPeriodicUpdates(String settlementId) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: periodicUpdateTime),
            (timer) async {
          _villageRepository
              .fetchSettlementById(settlementId);
          _messagesRepository.countNewMessages();
          _reportsRepository.fetchAllReportsBriefByUserId();
        });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
