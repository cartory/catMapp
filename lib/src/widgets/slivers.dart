import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SliverReload extends StatelessWidget {
  const SliverReload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Transform.scale(
          scale: .75,
          child: const CircularProgressIndicator(
            strokeWidth: 3,
            color: Color(0xff383D4A),
          ),
        ),
      ),
    );
  }
}

class SliverError extends StatelessWidget {
  final String message;
  final IconData iconData;

  const SliverError({
    Key? key,
    this.message = 'No Signal!',
    this.iconData = Icons.perm_scan_wifi_rounded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Transform.translate(
        offset: const Offset(0, -40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Get.theme.colorScheme.secondary,
              size: 70,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Get.theme.colorScheme.secondary,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
