import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:msmpusher/business/snapshot_cache/snapshot_cache.dart';
import 'package:msmpusher/core/constants.dart';
import 'package:msmpusher/core/theme/custom_typography.dart';
import 'package:msmpusher/core/util/width_constraints.dart';
import 'package:provider/provider.dart';

class SearchSliverAppBar extends StatefulWidget {
  final String title;
  final FocusNode focusNode;
  final TextEditingController controller;
  final Function(String) onSearchChangedCallback;
  final VoidCallback? onDisposeCallback;

  const SearchSliverAppBar({
    Key? key,
    required this.title,
    required this.focusNode,
    required this.controller,
    required this.onSearchChangedCallback,
    this.onDisposeCallback,
  }) : super(key: key);

  @override
  State<SearchSliverAppBar> createState() => _SearchSliverAppBarState();
}

class _SearchSliverAppBarState extends State<SearchSliverAppBar> {
  @override
  void dispose() {
    // reset isSearchingContactsMode
    // TODO: fix bug here
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        widget.onDisposeCallback!();
      }
    });

    super.dispose();
  }

  Widget _buildSearchTextField() {
    return TextFormField(
      controller: widget.controller,
      textAlignVertical: TextAlignVertical.center,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        hintText: 'Search ${widget.title}',
        // border: UnderlineInputBorder(),
        enabledBorder: InputBorder.none,
        border: InputBorder.none,
        prefixIcon: const Icon(Icons.search),
      ),
      onChanged: (value) => widget.onSearchChangedCallback(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      centerTitle: true,
      elevation: Sizing.kButtonElevation,
      title: Text(widget.title, style: Theme.of(context).textTheme.headline5),
      expandedHeight: (Sizing.kSizingMultiple * 12).h,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(-Sizing.kSizingMultiple),
        child: WidthConstraint(context).withHorizontalSymmetricalPadding(
          child: Material(
            // elevation: Sizing.kButtonElevation,
            color: CustomTypography.kWhiteColor,
            child: Column(
              children: [
                _buildSearchTextField(),
                Divider(
                  height: Sizing.kZeroValue,
                  color: CustomTypography.kLightGreyColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
