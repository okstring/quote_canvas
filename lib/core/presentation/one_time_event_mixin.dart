import 'dart:async';

import 'package:flutter/material.dart';

mixin OneTimeEventMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription? _subscription;

  void listenEvent<E>(Stream<E> stream, void Function(E event) handleEvent) {
    _subscription?.cancel();
    _subscription = stream.listen((event) {
      handleEvent(event);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
