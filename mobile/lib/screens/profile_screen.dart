import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 16),
        children: [
          const SizedBox(height: 16),
          // Profile Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 16),
                Text(
                  appLocalizations.translate('userName'),
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  appLocalizations.translate('userEmail'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Options Section
          Text(
            appLocalizations.translate('settings'),
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          // Settings Item
          _buildSettingsItem(
            context,
            icon: Icons.settings_outlined,
            title: appLocalizations.translate('settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          // Privacy Item
          _buildSettingsItem(
            context,
            icon: Icons.lock_outline,
            title: appLocalizations.translate('privacy'),
            onTap: () {
              // TODO: Implement privacy
            },
          ),
          // Help & Support Item
          _buildSettingsItem(
            context,
            icon: Icons.help_outline,
            title: appLocalizations.translate('helpAndSupport'),
            onTap: () {
              // TODO: Implement help & support
            },
          ),
          // About Item
          _buildSettingsItem(
            context,
            icon: Icons.info_outline,
            title: appLocalizations.translate('about'),
            onTap: () {
              // TODO: Implement about
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
} 