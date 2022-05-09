import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class HeaderMenu extends StatefulWidget {
  const HeaderMenu({Key? key}) : super(key: key);

  @override
  _HeaderMenuState createState() => _HeaderMenuState();
}

class _HeaderMenuState extends State<HeaderMenu> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeHelper.headerButton,
      child: Center(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => HeaderMenuItem(
            iconData: menuItems(context)[index].iconData,
            title: menuItems(context)[index].title,
            isSelected: _selectedIndex == index,
            // onTapped: () {
            // TODO(all): remove setState with cubit
            //   setState(() {
            //     _selectedIndex = index;
            //   });
            //},
          ),
          separatorBuilder: (_, __) =>
              const SizedBox(width: SizeHelper.spaceSmall),
          itemCount: menuItems(context).length,
        ),
      ),
    );
  }

  List<MenuItemModel> menuItems(BuildContext context) {
    return [
      MenuItemModel(context.l10n.credentials, Icons.wallet_membership),
      MenuItemModel(context.l10n.nftS, Icons.image),
      MenuItemModel(context.l10n.tokens, Icons.flash_on_outlined),
    ];
  }
}
