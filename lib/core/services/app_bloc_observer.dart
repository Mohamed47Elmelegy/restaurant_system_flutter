import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/debug_console_messages.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log(DebugConsoleMessages.info('Event: ${bloc.runtimeType} => $event'));
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log(
      DebugConsoleMessages.debug(
        'Transition: ${bloc.runtimeType} => $transition',
      ),
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log(DebugConsoleMessages.error('Error: ${bloc.runtimeType} => $error'));
    super.onError(bloc, error, stackTrace);
  }
}
