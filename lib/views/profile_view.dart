import 'package:ecoroute/core/widgets/ecoroute_app_bar.dart';
import 'package:ecoroute/l10n/app_localizations.dart';
import 'package:ecoroute/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/constants/constants.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceBright,
      appBar: EcorouteAppBar(
        color: Theme.of(context).colorScheme.surfaceBright,
        title: AppLocalizations.of(context)!.profile,
        hasLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SizeConstants.s24),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.person, size: SizeConstants.s200),
              ProfileTile(
                leftText: AppLocalizations.of(context)!.email,
                rightText: context.read<AuthViewModel>().userData!.email,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String leftText;
  final String rightText;
  const ProfileTile({
    super.key,
    required this.leftText,
    required this.rightText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftText,
          style: TextStyle(
            fontSize: SizeConstants.s16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(rightText, style: TextStyle(fontSize: SizeConstants.s16)),
      ],
    );
  }
}
