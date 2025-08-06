import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/widgets/custom_indicator.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'widgets/category_card.dart';
import 'widgets/food_item_card.dart';
import 'widgets/banner_card.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return CustomLoadingIndicator(
            isLoading: true,
            child: const SizedBox.shrink(),
          );
        } else if (state is HomeError) {
          return Center(child: Text(state.message));
        } else if (state is HomeLoaded) {
          return _buildHomeContent(context, state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHomeContent(BuildContext context, HomeLoaded state) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(const RefreshHomeData());
      },
      child: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            scrolledUnderElevation: 1,
            automaticallyImplyLeading: false,
            expandedHeight: 200.h,
            floating: true,
            pinned: true,
            backgroundColor: ThemeHelper.getPrimaryColorForTheme(context),
            // // إضافة الأيقونات في actions لتظهر فقط عند السكرول
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: Colors.white, size: 24.sp),
                onPressed: () {
                  // إضافة منطق البحث هنا
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 24.sp,
                ),
                onPressed: () {
                  // إضافة منطق الكارت هنا
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ThemeHelper.getPrimaryColorForTheme(context),
                      ThemeHelper.getSecondaryColorForTheme(context),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, User!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'What would you like to eat?',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 30.sp,
                                color: ThemeHelper.getPrimaryColorForTheme(
                                  context,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.grey[600],
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Search for food...',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories
                  _buildCategoriesSection(state),
                  SizedBox(height: 24.h),
                  // Special Offers
                  _buildSpecialOffersSection(context, state),
                  SizedBox(height: 24.h),
                  // Popular Items
                  _buildPopularItemsSection(context, state),
                  SizedBox(height: 24.h),

                  // Recommended Items
                  _buildRecommendedItemsSection(context, state),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Categories
  Widget _buildCategoriesSection(HomeLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: CategoryCard(
                  category: category,
                  isSelected: state.selectedCategoryId == category.id,
                  onTap: () {
                    context.read<HomeBloc>().add(SelectCategory(category.id));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Popular Items
  Widget _buildPopularItemsSection(BuildContext context, HomeLoaded state) {
    //  final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular Items',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: TextStyle(
                  color: ThemeHelper.getPrimaryColorForTheme(context),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.popularItems.length,
            itemBuilder: (context, index) {
              final item = state.popularItems[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: FoodItemCard(foodItem: item),
              );
            },
          ),
        ),
      ],
    );
  }

  // Recommended Items
  Widget _buildRecommendedItemsSection(BuildContext context, HomeLoaded state) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommended',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: TextStyle(
                  color: ThemeHelper.getPrimaryColorForTheme(context),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.recommendedItems.length,
            itemBuilder: (context, index) {
              final item = state.recommendedItems[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: FoodItemCard(foodItem: item),
              );
            },
          ),
        ),
      ],
    );
  }

  // Special Offers
  Widget _buildSpecialOffersSection(BuildContext context, HomeLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Offers',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.banners.length,
            itemBuilder: (context, index) {
              final banner = state.banners[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: BannerCard(banner: banner),
              );
            },
          ),
        ),
      ],
    );
  }
}
