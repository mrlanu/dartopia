import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

PreferredSizeWidget buildAppBar() =>
    AppBar(
      centerTitle: true,
      title: const Text(''),
      backgroundColor: Color.fromRGBO(36, 126, 38, 1.0),
      actions: [
        IconButton(
            onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.gear))
      ],
      //backgroundColor: transparent,
      elevation: 0,
    );
