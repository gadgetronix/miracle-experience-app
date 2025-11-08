part of '../wavier_list_screen.dart';

class WaiverListAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String)? onSearchChanged;

  const WaiverListAppBar({super.key, this.onSearchChanged});

  @override
  State<WaiverListAppBar> createState() => _WaiverListAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _WaiverListAppBarState extends State<WaiverListAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorConst.whiteColor,
      elevation: 0.5,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: child),
        child: _isSearching
            ? Padding(
              padding: EdgeInsets.only(bottom: 10, right: 15),
              child: Row(
                  key: const ValueKey("searchMode"),
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: ColorConst.textColor, size: 20),
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                          _searchController.clear();
                        });
                        widget.onSearchChanged?.call('');
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        cursorColor: ColorConst.primaryColor,
                        decoration: InputDecoration(
                          hintText: AppString.search,
                          border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                          filled: true,
                          fillColor: ColorConst.dividerColor,
                          contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 15),
                        ),
                        style: fontStyleMedium16,
                        onChanged: widget.onSearchChanged,
                      ),
                    ),
                  ],
                ),
            )
            : Row(
                key: const ValueKey("normalMode"),
                children: [
                  const SizedBox(width: 16),
                  Text(
                    AppString.balloonSafariWaivers,
                    style: fontStyleBold18
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Image.asset(ImageAsset.icSearch, height: 20, width: 20,),
                    onPressed: () {
                      setState(() => _isSearching = true);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
