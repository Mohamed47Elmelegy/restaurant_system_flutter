import 'package:flutter/material.dart';
import 'package:restaurant_system_flutter/main.dart';
import '../../../../core/routes/app_routes.dart';
import 'address_option.dart';

class AddressSelectionDialog extends StatelessWidget {
  final String currentAddress;
  final Function(String) onAddressSelected;
  final VoidCallback? onManageAddresses;

  const AddressSelectionDialog({
    super.key,
    required this.currentAddress,
    required this.onAddressSelected,
    this.onManageAddresses,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Delivery Address'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AddressOption(
            title: 'Halal Lab office',
            subtitle: 'Current address',
            isSelected: currentAddress == 'Halal Lab office',
            onTap: () {
              onAddressSelected('Halal Lab office');
              Navigator.pop(context);
            },
          ),
          AddressOption(
            title: 'Home Address',
            subtitle: '123 Main Street',
            isSelected: currentAddress == 'Home Address',
            onTap: () {
              onAddressSelected('Home Address');
              Navigator.pop(context);
            },
          ),
          AddressOption(
            title: 'Add new address',
            subtitle: 'Add a new delivery address',
            isSelected: false,
            onTap: () =>
                navigatorKey.currentState?.pushNamed(AppRoutes.addAddress),
            leadingIcon: Icons.add_location,
          ),
          const Divider(),
          AddressOption(
            title: 'إدارة العناوين',
            subtitle: 'عرض وتعديل العناوين المحفوظة',
            isSelected: false,
            onTap: onManageAddresses ?? () {},
            leadingIcon: Icons.settings_outlined,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
