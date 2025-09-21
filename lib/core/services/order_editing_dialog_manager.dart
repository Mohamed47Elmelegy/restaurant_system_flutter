import 'package:flutter/material.dart';
import '../../features/orders/domain/entities/order_entity.dart';
import '../../features/orders/domain/entities/order_enums.dart';
import '../constants/dialog_constants.dart';
import 'order_editing_service.dart';

/// Manages order editing dialogs and logic
class OrderEditingDialogManager {
  static final OrderEditingService _editingService =
      OrderEditingService.instance;

  /// Show order editing dialog
  static void showEditOrderDialog(BuildContext context, OrderEntity order) {
    final capabilities = _editingService.getEditingCapabilities(order);

    if (!capabilities.canEdit) {
      _showCannotEditDialog(context, capabilities.reason);
      return;
    }

    if (order.type == OrderType.dineIn) {
      _showDineInEditDialog(context, order, capabilities);
    } else {
      _showRegularEditDialog(context, order, capabilities);
    }
  }

  /// Show dialog when order cannot be edited
  static void _showCannotEditDialog(BuildContext context, String? reason) {
    DialogConstants.showPlatformAlert(
      context: context,
      title: 'لا يمكن تعديل الطلب',
      content: reason ?? 'لا يمكن تعديل هذا الطلب في الوقت الحالي',
      primaryButtonText: 'حسناً',
    );
  }

  /// Show edit dialog for dine-in orders
  static void _showDineInEditDialog(
    BuildContext context,
    OrderEntity order,
    dynamic capabilities,
  ) {
    final title = 'إضافة منتجات للطلب #${order.id}';
    final content = capabilities.canAddItems
        ? 'يمكنك إضافة المزيد من المنتجات لطلبك قبل الدفع النهائي.\nميزة إضافة المنتجات قيد التطوير...'
        : 'لا يمكن إضافة منتجات جديدة لهذا الطلب حالياً.';

    DialogConstants.showPlatformAlert(
      context: context,
      title: title,
      content: content,
      primaryButtonText: 'حسناً',
    );
  }

  /// Show edit dialog for regular orders (delivery/pickup)
  static void _showRegularEditDialog(
    BuildContext context,
    OrderEntity order,
    dynamic capabilities,
  ) {
    final title = 'تعديل الطلب #${order.id}';
    final editActions = _buildEditActionsList(capabilities);

    final content = editActions.isNotEmpty
        ? 'يمكنك ${editActions.join(', ')} في طلب ${order.typeDisplayName}.\nميزة تعديل الطلب قيد التطوير...'
        : 'لا يمكن تعديل هذا الطلب حالياً.';

    DialogConstants.showPlatformAlert(
      context: context,
      title: title,
      content: content,
      primaryButtonText: 'حسناً',
    );
  }

  /// Build list of available edit actions
  static List<String> _buildEditActionsList(dynamic capabilities) {
    final actions = <String>[];

    if (capabilities.canAddItems) actions.add('إضافة منتجات');
    if (capabilities.canRemoveItems) actions.add('حذف منتجات');
    if (capabilities.canModifyItems) actions.add('تعديل المنتجات');
    if (capabilities.canChangeQuantity) actions.add('تغيير الكمية');

    return actions;
  }
}
