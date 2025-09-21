import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common_empty_state.dart';
import 'common_error_state.dart';
import 'common_loading_widget.dart';

/// نموذج موحد لبناء الحالات المختلفة
class CommonStateBuilder<B extends StateStreamable<S>, S>
    extends StatelessWidget {
  final BlocWidgetBuilder<S> builder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context, String message)? errorBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final bool Function(S state) isLoading;
  final bool Function(S state) hasError;
  final bool Function(S state) isEmpty;
  final String Function(S state)? getErrorMessage;
  final String? loadingMessage;
  final BlocBuilderCondition<S>? buildWhen;

  const CommonStateBuilder({
    super.key,
    required this.builder,
    required this.isLoading,
    required this.hasError,
    required this.isEmpty,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.getErrorMessage,
    this.loadingMessage,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      buildWhen: buildWhen,
      builder: (context, state) {
        // Loading State
        if (isLoading(state)) {
          if (loadingBuilder != null) {
            return loadingBuilder!(context);
          }
          return loadingMessage != null
              ? CommonLoadingWidget.withMessage(loadingMessage!)
              : const CommonLoadingWidget();
        }

        // Error State
        if (hasError(state)) {
          final message = getErrorMessage?.call(state) ?? 'حدث خطأ غير متوقع';
          if (errorBuilder != null) {
            return errorBuilder!(context, message);
          }
          return CommonErrorState.general(
            message: message,
            onRetry: () {
              // يمكن إضافة منطق إعادة المحاولة هنا إذا لزم الأمر
            },
          );
        }

        // Empty State
        if (isEmpty(state)) {
          if (emptyBuilder != null) {
            return emptyBuilder!(context);
          }
          return const CommonEmptyStateSimple(
            message: 'لا توجد بيانات للعرض',
            icon: Icons.inbox_outlined,
          );
        }

        // Content State
        return builder(context, state);
      },
    );
  }
}

/// نموذج مخصص للقوائم
class CommonListStateBuilder<B extends StateStreamable<S>, S, T>
    extends StatelessWidget {
  final Widget Function(BuildContext context, List<T> items) listBuilder;
  final List<T> Function(S state) getItems;
  final bool Function(S state) isLoading;
  final bool Function(S state) hasError;
  final String Function(S state)? getErrorMessage;
  final VoidCallback? onRetry;
  final String? loadingMessage;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final BlocBuilderCondition<S>? buildWhen;

  const CommonListStateBuilder({
    super.key,
    required this.listBuilder,
    required this.getItems,
    required this.isLoading,
    required this.hasError,
    this.getErrorMessage,
    this.onRetry,
    this.loadingMessage,
    this.emptyWidget,
    this.errorWidget,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      buildWhen: buildWhen,
      builder: (context, state) {
        // Loading State
        if (isLoading(state)) {
          return loadingMessage != null
              ? CommonLoadingWidget.withMessage(loadingMessage!)
              : const CommonLoadingWidget();
        }

        // Error State
        if (hasError(state)) {
          if (errorWidget != null) return errorWidget!;

          final message = getErrorMessage?.call(state) ?? 'حدث خطأ غير متوقع';
          return CommonErrorState.general(message: message, onRetry: onRetry);
        }

        // Get items
        final items = getItems(state);

        // Empty State
        if (items.isEmpty) {
          return emptyWidget ??
              const CommonEmptyStateSimple(
                message: 'لا توجد عناصر للعرض',
                icon: Icons.inbox_outlined,
              );
        }

        // List Content
        return listBuilder(context, items);
      },
    );
  }
}
