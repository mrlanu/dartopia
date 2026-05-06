import 'package:dartopia/consts/colors.dart';
import 'package:dartopia/world_map/cubit/world_map_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapButtonRow extends StatelessWidget {
  const MapButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton.outlined(
          color: DartopiaColors.primary,
          iconSize: 40,
          onPressed: () {
            context.read<WorldMapCubit>().recenterToVillage();
          },
          icon: const Icon(Icons.home),
        ),
      ],
    );
  }
}
