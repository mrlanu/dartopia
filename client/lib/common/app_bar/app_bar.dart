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
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromRGBO(36, 126, 38, 1.0),
      actions: [
        IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.gear))
      ],
      //backgroundColor: transparent,
      elevation: 0,
    );
