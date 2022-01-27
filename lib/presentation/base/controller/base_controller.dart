import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_template/foundation/logger/logger.dart';
import 'package:flutter_template/presentation/entity/screen/screen.dart';
import 'package:flutter_template/presentation/entity/screen/screen_state.dart';
import 'package:get/get.dart';

abstract class BaseController<SCREEN extends Screen,
    SCREEN_STATE extends ScreenState> extends GetxController {
  late Rx<SCREEN_STATE> _state;

  Rx<SCREEN_STATE> get rxState => _state;

  SCREEN_STATE get state => _state.value;

  SCREEN_STATE getDefaultState();

  SCREEN? get screen {
    try {
      return Get.arguments as SCREEN?;
    } catch (e) {
      log.e("Incorrect arguments. Required type $SCREEN.", e);
      return null;
    }
  }

  final List<StreamSubscription> _streamSubscriptions =
      List.empty(growable: true);

  @override
  void onInit() {
    super.onInit();
    _state = getDefaultState().obs;
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    super.onClose();
    for (var subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  setState(SCREEN_STATE Function(SCREEN_STATE state) reducer) {
    final newState = reducer(state);
    if (!const DeepCollectionEquality().equals(_state.value, newState)) {
      _state.value = newState;
    }
  }

  listen<T>(
      {required Stream<T> stream, required void Function(T data) onData}) {
    final subscription = stream.listen(onData);
    _streamSubscriptions.add(subscription);
  }
}
