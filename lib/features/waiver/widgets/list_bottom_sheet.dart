part of '../wavier_list_screen.dart';

class ListBottomSheet {
  static void buildSheet({
    required BuildContext context,
    required String title,
    required List<String> items,
    required String currentValue,
    Function(String selectedItem)? onTap,
  }) {
    CustomBottomSheet.instance.modalBottomSheet(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 35),
          Center(child: Text(title, style: fontStyleSemiBold18)),
          const SizedBox(height: 25),
          Flexible(
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (context, int index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConst.dividerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Center(
                      child: Text(
                        items[index],
                        style: fontStyleSemiBold16,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    trailing: items[index] == currentValue
                        ? const Icon(
                            Icons.check,
                            color: ColorConst.primaryColor,
                            size: 20,
                          )
                        : const SizedBox(width: 20, height: 20),
                    leading: const SizedBox(width: 20, height: 20),
                    onTap: () {
                      onTap?.call(items[index]);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

}