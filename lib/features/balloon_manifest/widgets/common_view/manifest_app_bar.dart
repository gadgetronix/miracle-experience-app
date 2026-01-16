part of '../../balloon_manifest_screen.dart';

class ManifestAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ManifestAppBar({super.key, required this.helper});

  final BalloonManifestHelper helper;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        AppString.balloonManifest,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: FontAsset.helvetica,
        ),
      ),
      elevation: 2,
      centerTitle: true,
      backgroundColor: ColorConst.whiteColor,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Icon(Icons.menu_rounded),
        ),
      ),
    );
  }
}
