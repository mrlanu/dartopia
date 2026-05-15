import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:models/models.dart';

import '../../../consts/colors.dart';
import '../../../settings/cubit/settings_cubit.dart';
import '../../../settlement/settlement.dart';
import '../../../utils/utils.dart';

class FieldViewTile extends StatelessWidget {
  final List<int> buildingRecord;
  final List<double> storage;
  final int? isUpgrading;
  final int constructionsTaskAmount;

  const FieldViewTile(
      {super.key,
      required this.buildingRecord,
      required this.constructionsTaskAmount,
      required this.storage,
      this.isUpgrading});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsCubit>().state.settings;
    final specification = buildingSpecefication[buildingRecord[1]]!;
    final prod = specification.benefit(buildingRecord[2]).toInt()
        * settings!.productionMultiplier;
    final prodNext = specification.benefit(buildingRecord[2] + 1).toInt()
        * settings.productionMultiplier;
    final cost = specification.getResourcesToNextLevel(buildingRecord[2] + 1);
    final canBeUpgraded = buildingRecord[3] == 1 ? true : false;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                    backgroundColor: _getColor(),
                    child: Text(
                      '${buildingRecord[2]}',
                      style: textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: DartopiaColors.black),
                    )),
                Text(
                  '$prod/hr',
                  style: textTheme.labelSmall,
                ),
              ],
            ),
            Expanded(
                child: isUpgrading != null
                    ? _upgradingBody(
                        context, isUpgrading!, buildingRecord[2] + 1)
                    : _notUpgradingBody(
                        context,
                        cost,
                        specification.time.valueOf(buildingRecord[2] + 1) ~/
                            settings.buildingsSpeedX)),
            Column(
              children: [
                IconButton.outlined(
                    color: Colors.green,
                    onPressed: canBeUpgraded && isUpgrading == null
                        ? () {
                            final request = ConstructionRequest(
                                specificationId: buildingRecord[1],
                                buildingId: buildingRecord[0],
                                toLevel: buildingRecord[2] + 1);
                            context.read<SettlementBloc>().add(
                                BuildingUpgradeRequested(request: request));
                          }
                        : null,
                    icon: const Icon(Icons.update)),
                Text(
                  '$prodNext/hr',
                  style: textTheme.labelSmall,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Color _getColor() {
    final canBeUpgraded = buildingRecord[3] == 1 ? true : false;
    final canBeUpgradedWithGold = buildingRecord[3] == 2 ? true : false;
    Color labelBackground;
    if (canBeUpgraded) {
      labelBackground = DartopiaColors.primaryContainer;
    } else if (canBeUpgradedWithGold) {
      labelBackground = DartopiaColors.secondaryContainer;
    } else {
      labelBackground = DartopiaColors.grey;
    }
    return labelBackground;
  }

  Widget _upgradingBody(BuildContext context, int duration, int lvl) {
    return Column(
      children: [
        Text(
          'Upgrading to lvl: $lvl',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        CountdownTimer(
          startValue: duration,
          onFinish: () {
            context
                .read<SettlementBloc>()
                .add(const SettlementFetchRequested());
          },
        ),
      ],
    );
  }

  Widget _notUpgradingBody(BuildContext context, List<int> cost, int time) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _resItemBuilder(
                context: context,
                cost: cost,
                assetPath: DartopiaImages.lumber,
                itemPosition: 0),
            _resItemBuilder(
                context: context,
                cost: cost,
                assetPath: DartopiaImages.clay,
                itemPosition: 1),
            _resItemBuilder(
                context: context,
                cost: cost,
                assetPath: DartopiaImages.iron,
                itemPosition: 2),
            _resItemBuilder(
                context: context,
                cost: cost,
                assetPath: DartopiaImages.crop,
                itemPosition: 3),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(DartopiaImages.clock, height: 11.h),
            SizedBox(width: 3.w),
            Text(
              FormatUtil.formatTime(time),
              style: textTheme.bodySmall,
            )
          ],
        ),
      ],
    );
  }

  Widget _resItemBuilder({
      required BuildContext context,
      required List<int> cost,
      required String assetPath,
      required int itemPosition,
      double imageHeight = 11}) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(assetPath, height: imageHeight.h),
        SizedBox(width: 2.w),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${cost[itemPosition]}',
              style: textTheme.bodySmall!.copyWith(
                  color: cost[itemPosition] < storage[itemPosition]
                      ? null
                      : Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
