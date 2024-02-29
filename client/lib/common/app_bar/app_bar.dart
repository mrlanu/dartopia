import 'package:dartopia/consts/calors.dart';
import 'package:dartopia/settlement/bloc/settlement_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

PreferredSizeWidget buildAppBar() => AppBar(
      centerTitle: true,
      title: BlocBuilder<SettlementBloc, SettlementState>(
        builder: (context, state) {
          return Text(
            state.settlement?.name ?? '');
        },
      ),
      foregroundColor: DartopiaColors.onPrimary,
      backgroundColor: DartopiaColors.primary,
      actions: [
        IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.gear))
      ],
      //backgroundColor: transparent,
      elevation: 0,
    );
