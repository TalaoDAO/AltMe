import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
    required this.accountName,
    this.onMenuTapped,
    this.onScanTapped,
  }) : super(key: key);

  final VoidCallback? onMenuTapped;
  final VoidCallback? onScanTapped;
  final String accountName;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).darkGradient,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      title: _buildTitle(context),
      leading: IconButton(
        onPressed: onMenuTapped,
        icon: const Icon(
          Icons.menu_rounded,
          color: AppTheme.darkOnSurface,
          size: SizeHelper.iconNormal,
        ),
      ),
      actions: [
        IconButton(
          onPressed: onScanTapped,
          icon: const Icon(
            // TODO(all): change icons
            Icons.qr_code_scanner_rounded,
            color: AppTheme.darkOnSurface,
            size: SizeHelper.iconNormal,
          ),
        )
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.account_circle,
          color: AppTheme.darkOnSurface,
          size: SizeHelper.iconSmall,
        ),
        const SizedBox(
          width: SizeHelper.space2XSmall,
        ),
        Text(
          accountName.toUpperCase(),
          style: Theme.of(context).textTheme.subtitle2,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
