import 'package:dar_plus_app/main.dart';

/// Localized label for an owner/agent role from the API.
String localizedOwnerRole(String role) {
  switch (role.trim().toLowerCase()) {
    case 'owner':
      return tr.owner;
    case 'agent':
      return tr.role_agent;
    case 'user':
      return tr.role_user;
    default:
      return role;
  }
}

/// Localized label for an owner account status from the API.
String localizedOwnerStatus(String status) {
  final normalized = status.trim().toLowerCase();
  if (normalized.isEmpty) return '';

  if (normalized.contains('block')) return tr.owner_status_blocked;
  if (normalized.contains('verified')) return tr.owner_status_verified;
  if (normalized.contains('active')) return tr.owner_status_active;
  if (normalized.contains('inactive')) return tr.owner_status_inactive;
  if (normalized.contains('pending')) return tr.pending;

  return status;
}

/// Status chip text — falls back to role when status is empty.
String localizedOwnerStatusOrRole({required String status, required String role}) {
  if (status.trim().isEmpty) return localizedOwnerRole(role);
  return localizedOwnerStatus(status);
}
