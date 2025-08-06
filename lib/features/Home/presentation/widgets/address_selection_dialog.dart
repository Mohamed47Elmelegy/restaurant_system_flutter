import 'package:flutter/material.dart';
import 'address_option.dart';

class AddressSelectionDialog extends StatelessWidget {
  final String currentAddress;
  final Function(String) onAddressSelected;

  const AddressSelectionDialog({
    super.key,
    required this.currentAddress,
    required this.onAddressSelected,
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
            onTap: () => Navigator.pop(context),
            leadingIcon: Icons.add_location,
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
