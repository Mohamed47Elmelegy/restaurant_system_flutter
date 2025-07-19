// import 'package:flutter/material.dart';
// import 'theme_switch_widget.dart';
// import 'app_bar_helper.dart';

// class SettingsPage extends StatelessWidget {
//   const SettingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarHelper.createAppBar(
//         title: 'Settings',
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.info_outline),
//             onPressed: () {
//               _showThemeInfo(context);
//             },
//           ),
//         ],
//       ),
//       body: ListView(
//         children: [
//           const SizedBox(height: 16),

//           // Theme Section
//           Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     'Appearance',
//                     style: Theme.of(context).textTheme.headlineSmall,
//                   ),
//                 ),
//                 const ThemeModeSelector(),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),

//           // Quick Theme Toggle
//           Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: const ThemeSwitchWidget(),
//           ),

//           // Theme Preview Section
//           Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Theme Preview',
//                     style: Theme.of(context).textTheme.headlineSmall,
//                   ),
//                   const SizedBox(height: 16),

//                   // Buttons Preview
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           child: const Text('Primary Button'),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () {},
//                           child: const Text('Secondary'),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // Text Field Preview
//                   TextField(
//                     decoration: InputDecoration(
//                       labelText: 'Sample Input',
//                       hintText: 'Enter some text...',
//                       border: const OutlineInputBorder(),
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   // Color Palette Preview
//                   Text(
//                     'Color Palette',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 8),
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 8,
//                     children: [
//                       _buildColorChip(
//                         context,
//                         'Primary',
//                         Theme.of(context).colorScheme.primary,
//                       ),
//                       _buildColorChip(
//                         context,
//                         'Secondary',
//                         Theme.of(context).colorScheme.secondary,
//                       ),
//                       _buildColorChip(
//                         context,
//                         'Surface',
//                         Theme.of(context).colorScheme.surface,
//                       ),
//                       _buildColorChip(
//                         context,
//                         'Surface',
//                         Theme.of(context).colorScheme.surface,
//                       ),
//                       _buildColorChip(
//                         context,
//                         'Error',
//                         Theme.of(context).colorScheme.error,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildColorChip(BuildContext context, String label, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
//         ),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   void _showThemeInfo(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Theme Information'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Light Theme Colors:',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               '• Primary: #FF8008 (Orange)\n• Secondary: #FFC837 (Light Orange)\n• Background: #FFF5E1 (Cream)\n• Text: #1B1B1B (Dark Gray)',
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Dark Theme Colors:',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               '• Primary: #BB86FC (Purple)\n• Secondary: #03DAC6 (Teal)\n• Background: #121212 (Dark Gray)\n• Surface: #1F1F1F (Lighter Dark)\n• Text: #FFFFFF (White)',
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }
// }
