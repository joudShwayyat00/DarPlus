import 'package:dar_plus_app/core/constants/app_currency.dart';
import 'package:dar_plus_app/configuration/app_colors.dart';
import 'package:dar_plus_app/features/assets/data/models/asset_item.dart';
import 'package:dar_plus_app/screens/asset_details/asset_details_screen.dart';
import 'package:dar_plus_app/screens/assets/top_rated_screen.dart';
import 'package:dar_plus_app/screens/home/widgets/property_tile.dart';
import 'package:dar_plus_app/screens/home/widgets/section_header.dart';
import 'package:dar_plus_app/utils/widgets/filter_bottom_sheet.dart';
import 'package:dar_plus_app/utils/helpers/app_navigation.dart';
import 'package:dar_plus_app/utils/ui/app_back_button.dart';
import 'package:dar_plus_app/utils/ui/app_text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dar_plus_app/features/assets/presentation/providers/assets_providers.dart';
import 'package:dar_plus_app/features/search/presentation/providers/search_providers.dart';
import 'package:dar_plus_app/features/search/presentation/providers/recent_search_providers.dart';
import 'package:dar_plus_app/utils/ui/shimmer_placeholder.dart';
import 'package:sizer/sizer.dart';
import 'package:dar_plus_app/main.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final bool showBackButton;
  final FilterData? initialFilter;

  const SearchScreen({
    super.key,
    this.showBackButton = false,
    this.initialFilter,
  });

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  static const int _recentPreviewCount = 3;
  static const int _popularPreviewCount = 5;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final PageController _topRatedController = PageController(
    viewportFraction: 0.92,
  );
  int _currentTopRatedIndex = 0;
  FilterData _activeFilter = FilterData.empty;
  bool _showAllRecent = false;
  bool _showAllPopular = false;
  bool _initialFilterApplied = false;

  // recent searches are fetched from the API; no local fallbacks kept here

  @override
  void initState() {
    super.initState();
    final initial = widget.initialFilter;
    if (initial != null && initial.hasActiveFilters) {
      _activeFilter = initial;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialFilterApplied ||
        widget.initialFilter == null ||
        !widget.initialFilter!.hasActiveFilters) {
      return;
    }
    _initialFilterApplied = true;
    ref.invalidate(filteredAssetsControllerProvider(_activeFilter));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _topRatedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Search Field
            _buildSearchHeader(context),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.5.h),

                    if (!_activeFilter.hasActiveFilters &&
                        _searchController.text.trim().isEmpty)
                      _buildRecentSection(),

                    // Search results (when typing) or filter/discovery content
                    _buildSearchContent(),

                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.showBackButton) const AppBackButton(),
              if (widget.showBackButton) SizedBox(width: 3.w),
              Text(
                tr.search,
                style: appTextStyle(
                  context,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withAlpha(240),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withAlpha(12)),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: appTextStyle(
                context,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withAlpha(220),
              ),
              decoration: InputDecoration(
                hintText: tr.search_hint,
                hintStyle: appTextStyle(
                  context,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withAlpha(100),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.goldBrandColor,
                  size: 22,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.black.withAlpha(140),
                          size: 20,
                        ),
                      )
                    : _FilterButton(
                        activeCount: _activeFilter.activeCount,
                        onTap: _openFilterSheet,
                      ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.6.h,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openFilterSheet() async {
    final result = await showFilterBottomSheet(
      context,
      initial: _activeFilter,
    );
    if (result == null) return;
    setState(() => _activeFilter = result);
    if (result.hasActiveFilters) {
      ref.invalidate(filteredAssetsControllerProvider(result));
    }
  }

  /// Switches between text search, filter results, and discovery sections.
  Widget _buildSearchContent() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      return _buildSearchResults(query);
    }
    if (_activeFilter.hasActiveFilters) {
      return _buildFilterResults();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(tr.popular_searches),
        SizedBox(height: 1.2.h),
        _buildPopularSearches(),
        SizedBox(height: 2.8.h),
        SectionHeader(
          title: tr.top_rated,
          onSeeAll: () =>
              AppNavigator.of(context).push(const TopRatedScreen()),
        ),
        _buildTopRated(),
      ],
    );
  }

  Widget _buildFilterResults() {
    final resultsAsync = ref.watch(
      filteredAssetsControllerProvider(_activeFilter),
    );

    return resultsAsync.when(
      loading: () => Column(
        children: List.generate(
          4,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: 1.5.h),
            child: ShimmerPlaceholder(
              width: double.infinity,
              height: 10.h,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      error: (err, __) => Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Text(
            err.toString(),
            style: appTextStyle(
              context,
              fontSize: 11.sp,
              color: Colors.red.shade400,
            ),
          ),
        ),
      ),
      data: (assets) {
        if (assets.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Column(
                children: [
                  Icon(
                    Icons.filter_alt_off_rounded,
                    size: 48,
                    color: Colors.black.withAlpha(60),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    tr.no_results_found,
                    style: appTextStyle(
                      context,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withAlpha(120),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(tr.filter_title),
            SizedBox(height: 1.2.h),
            ...assets.map(
              (asset) => _AssetResultTile(
                asset: asset,
                onTap: () => AppNavigator.of(context).push(
                  AssetDetailsScreen(assetId: asset.id, initialAsset: asset),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults(String query) {
    final resultsAsync = ref.watch(assetSearchControllerProvider(query));

    return resultsAsync.when(
      loading: () => Column(
        children: List.generate(
          4,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: 1.5.h),
            child: ShimmerPlaceholder(
              width: double.infinity,
              height: 10.h,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      error: (err, __) => Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Text(
            err.toString(),
            style: appTextStyle(
              context,
              fontSize: 11.sp,
              color: Colors.red.shade400,
            ),
          ),
        ),
      ),
      data: (assets) {
        if (assets.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 48,
                    color: Colors.black.withAlpha(60),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    tr.no_results_found,
                    style: appTextStyle(
                      context,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withAlpha(120),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Column(
          children: assets
              .map(
                (asset) => _AssetResultTile(
                  asset: asset,
                  onTap: () => AppNavigator.of(context).push(
                    AssetDetailsScreen(assetId: asset.id, initialAsset: asset),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: appTextStyle(
        context,
        fontSize: 13.sp,
        fontWeight: FontWeight.w900,
        color: Colors.black.withAlpha(240),
      ),
    );
  }

  List<T> _previewItems<T>(List<T> items, bool showAll, int previewCount) {
    if (showAll || items.length <= previewCount) return items;
    return items.take(previewCount).toList();
  }

  Widget? _buildShowMoreButton({
    required int totalCount,
    required int previewCount,
    required bool showAll,
    required VoidCallback onTap,
  }) {
    if (totalCount <= previewCount) return null;

    return Padding(
      padding: EdgeInsets.only(top: 0.8.h),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.4.h),
            foregroundColor: AppColors.goldBrandColor,
          ),
          onPressed: onTap,
          child: Text(
            showAll ? tr.show_less : tr.show_more,
            style: appTextStyle(
              context,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.goldBrandColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSection() {
    final recentAsync = ref.watch(recentSearchControllerProvider);

    return recentAsync.when(
      data: (items) {
        // Hide section when API returns empty
        if (items.isEmpty) return const SizedBox.shrink();

        final visibleItems =
            _previewItems(items, _showAllRecent, _recentPreviewCount);
        final showMoreButton = _buildShowMoreButton(
          totalCount: items.length,
          previewCount: _recentPreviewCount,
          showAll: _showAllRecent,
          onTap: () => setState(() => _showAllRecent = !_showAllRecent),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(tr.recent_searches),
            SizedBox(height: 1.2.h),
            Column(
              children: visibleItems.map((search) {
                final display = search.toString();
                return _RecentSearchTile(
                  text: display,
                  onTap: () {
                    _searchController.text = display;
                    setState(() {});
                  },
                  onRemove: () {},
                );
              }).toList(),
            ),
            if (showMoreButton != null) showMoreButton,
            SizedBox(height: 2.8.h),
          ],
        );
      },
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(tr.recent_searches),
          SizedBox(height: 1.2.h),
          Column(
            children: List.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 1.2.h),
                child: ShimmerPlaceholder(
                  width: double.infinity,
                  height: 4.h,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.8.h),
        ],
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildPopularSearches() {
    final popularAsync = ref.watch(popularSearchControllerProvider);

    return popularAsync.when(
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();

        final visibleItems =
            _previewItems(items, _showAllPopular, _popularPreviewCount);
        final showMoreButton = _buildShowMoreButton(
          totalCount: items.length,
          previewCount: _popularPreviewCount,
          showAll: _showAllPopular,
          onTap: () => setState(() => _showAllPopular = !_showAllPopular),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 2.5.w,
              runSpacing: 1.2.h,
              children: visibleItems.map((search) {
                final display = search;
                return _SearchChip(
                  text: display,
                  onTap: () {
                    _searchController.text = display;
                    setState(() {});
                  },
                );
              }).toList(),
            ),
            if (showMoreButton != null) showMoreButton,
          ],
        );
      },
      loading: () => Wrap(
        spacing: 2.5.w,
        runSpacing: 1.2.h,
        children: List.generate(
          5,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 1.2.h),
            child: ShimmerPlaceholder(
              width: 28.w,
              height: 3.6.h,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
      error: (err, st) {
        // Fallback to empty or default items on error
        return Wrap(spacing: 2.5.w, runSpacing: 1.2.h, children: []);
      },
    );
  }

  Widget _buildTopRated() {
    final topRatedAsync = ref.watch(topRatedAssetsControllerProvider);

    return topRatedAsync.when(
      data: (assets) {
        if (assets.isEmpty) return const SizedBox.shrink();

        final preview = assets.take(5).toList();

        return Column(
          children: [
            SizedBox(
              height: 43.h,
              child: GestureDetector(
                onTap: () => AppNavigator.of(context).push(
                  AssetDetailsScreen(
                    assetId: preview[_currentTopRatedIndex].id,
                    initialAsset: preview[_currentTopRatedIndex],
                  ),
                ),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification) {
                      final page = _topRatedController.page ?? 0;
                      final newIndex = page.round();
                      if (newIndex != _currentTopRatedIndex) {
                        setState(() => _currentTopRatedIndex = newIndex);
                      }
                    }
                    return false;
                  },
                  child: PageView.builder(
                    controller: _topRatedController,
                    itemCount: preview.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == preview.length - 1 ? 0 : 3.w,
                        ),
                        child: PropertyTile(
                          item: preview[index].toPropertyItem(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                preview.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentTopRatedIndex == index ? 18 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: _currentTopRatedIndex == index
                        ? AppColors.goldBrandColor
                        : AppColors.grayBrandColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => SizedBox(
        height: 43.h,
        child: ShimmerPlaceholder(
          width: double.infinity,
          height: double.infinity,
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

// ─── Search Result Tile ───────────────────────────────────────────────────────

class _AssetResultTile extends StatelessWidget {
  final AssetItem asset;
  final VoidCallback onTap;

  const _AssetResultTile({required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isForSale = asset.isForSale;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 1.5.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withAlpha(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: asset.image,
                width: 18.w,
                height: 10.h,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey.shade200),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.image_not_supported_rounded,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.3.h,
                        ),
                        decoration: BoxDecoration(
                          color: isForSale
                              ? const Color(0xFF1B6B2F)
                              : AppColors.goldBrandColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          isForSale ? tr.for_sale : tr.for_rent,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.5.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppColors.goldBrandColor,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        asset.rating.toStringAsFixed(1),
                        style: appTextStyle(
                          context,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black.withAlpha(210),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    asset.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: appTextStyle(
                      context,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.black.withAlpha(230),
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Row(
                    children: [
                      Icon(
                        Icons.place_rounded,
                        size: 12,
                        color: Colors.black.withAlpha(120),
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          asset.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: appTextStyle(
                            context,
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withAlpha(140),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.4.h),
                  Text(
                    formatPrice(asset.price),
                    style: appTextStyle(
                      context,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.goldBrandColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.black.withAlpha(80),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentSearchTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _RecentSearchTile({
    required this.text,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.2.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.2.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.history_rounded,
                size: 18,
                color: Colors.black.withAlpha(150),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                text,
                style: appTextStyle(
                  context,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withAlpha(200),
                ),
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: Icon(
                Icons.close_rounded,
                size: 18,
                color: Colors.black.withAlpha(120),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SearchChip({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        splashColor: AppColors.goldBrandColor.withAlpha(35),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.1.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.goldBrandColor.withAlpha(80)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.trending_up_rounded,
                size: 16,
                color: AppColors.goldBrandColor,
              ),
              SizedBox(width: 1.5.w),
              Text(
                text,
                style: appTextStyle(
                  context,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withAlpha(200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Filter Icon Button with badge ───────────────────────────────────────────

class _FilterButton extends StatelessWidget {
  final int activeCount;
  final VoidCallback onTap;

  const _FilterButton({required this.activeCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 2.w),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.tune_rounded,
              color: activeCount > 0
                  ? AppColors.goldBrandColor
                  : Colors.black.withAlpha(140),
              size: 22,
            ),
            if (activeCount > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.goldBrandColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$activeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
