import 'package:dar_plus_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:dar_plus_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

bool isCurrentUserAssetOwner(BuildContext context, int? assetOwnerId) {
  if (assetOwnerId == null) return false;

  final userId = ProviderScope.containerOf(
    context,
    listen: false,
  ).read(profileControllerProvider).value?.id;

  if (userId == null) return false;
  return userId == assetOwnerId;
}

void showOwnAssetActionBlockedMessage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(tr.cannot_book_own_property)),
  );
}
