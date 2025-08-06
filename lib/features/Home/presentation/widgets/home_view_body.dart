import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import 'home_custom_app_bar.dart';
import 'home_content.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  String currentAddress = 'Halal Lab office';
  int cartItemCount = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom App Bar
        HomeCustomAppBar(
          currentAddress: currentAddress,
          cartItemCount: cartItemCount,
          onAddressChanged: (newAddress) {
            setState(() {
              currentAddress = newAddress;
            });
          },
          onCartItemCountChanged: (newCount) {
            setState(() {
              cartItemCount = newCount;
            });
          },
        ),

        // Page Content
        Expanded(
          child: HomeContent(
            onRefresh: () async {
              context.read<HomeBloc>().add(const RefreshHomeData());
            },
          ),
        ),
      ],
    );
  }
}
