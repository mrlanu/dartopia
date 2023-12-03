import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/world_bloc.dart';

class MapButtonRow extends StatelessWidget {
  const MapButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton.outlined(
            color: Colors.green,
            onPressed: () {
              context.read<WorldBloc>().add(XDecremented());
            },
            icon: const Icon(Icons.arrow_back_outlined)),
        IconButton.outlined(
            iconSize: 30,
            color: Colors.green,
            onPressed: () {
              context.read<WorldBloc>().add(YDecremented());
            },
            icon: const Icon(Icons.arrow_downward_outlined)),
        IconButton.outlined(
            iconSize: 40,
            color: Colors.green,
            onPressed: () {
              context.read<WorldBloc>().add(CenterRequested());
            },
            icon: const Icon(Icons.home)),
        IconButton.outlined(
            iconSize: 30,
            color: Colors.green,
            onPressed: () {
              context.read<WorldBloc>().add(YIncremented());
            },
            icon: const Icon(Icons.arrow_upward_outlined)),
        IconButton.outlined(
            color: Colors.green,
            onPressed: () {
              context.read<WorldBloc>().add(XIncremented());
            },
            icon: const Icon(Icons.arrow_forward_outlined)),
      ],
    );
  }
}
