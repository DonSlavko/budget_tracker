import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return Scaffold(
      body: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return ListView(
            padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 16),
            children: [
              const SizedBox(height: 16),
              // Profile Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
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
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      appLocalizations.translate('userEmail'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Settings Section
              Text(
                appLocalizations.translate('settings'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              // Theme Mode Selection
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        appLocalizations.translate('theme'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).colorScheme.surface.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: SegmentedButton<ThemeMode>(
                          segments: [
                            ButtonSegment<ThemeMode>(
                              value: ThemeMode.light,
                              label: Text(appLocalizations.translate('light')),
                              icon: Icon(
                                Icons.light_mode,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            ButtonSegment<ThemeMode>(
                              value: ThemeMode.dark,
                              label: Text(appLocalizations.translate('dark')),
                              icon: Icon(
                                Icons.dark_mode,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            ButtonSegment<ThemeMode>(
                              value: ThemeMode.system,
                              label: Text(appLocalizations.translate('system')),
                              icon: Icon(
                                Icons.settings_suggest,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                          selected: {themeProvider.themeMode},
                          onSelectionChanged: (Set<ThemeMode> newSelection) {
                            themeProvider.setThemeMode(newSelection.first);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Language Selection
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        appLocalizations.translate('language'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).colorScheme.surface.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: SegmentedButton<String>(
                          segments: [
                            ButtonSegment<String>(
                              value: 'en',
                              label: Text(appLocalizations.translate('english')),
                              icon: Icon(
                                Icons.language,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            ButtonSegment<String>(
                              value: 'sr',
                              label: Text(appLocalizations.translate('serbian')),
                              icon: Icon(
                                Icons.language,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                          selected: {languageProvider.locale.languageCode},
                          onSelectionChanged: (Set<String> newSelection) {
                            final languageCode = newSelection.first;
                            if (languageCode == 'en') {
                              languageProvider.setEnglish();
                            } else if (languageCode == 'sr') {
                              languageProvider.setSerbian();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Other Settings Items
              _buildSettingsItem(
                context,
                icon: Icons.notifications_outlined,
                title: appLocalizations.translate('notifications'),
                onTap: () {
                  // TODO: Implement notifications settings
                },
              ),
              _buildSettingsItem(
                context,
                icon: Icons.lock_outline,
                title: appLocalizations.translate('privacy'),
                onTap: () {
                  // TODO: Implement privacy settings
                },
              ),
              _buildSettingsItem(
                context,
                icon: Icons.help_outline,
                title: appLocalizations.translate('helpAndSupport'),
                onTap: () {
                  // TODO: Implement help & support
                },
              ),
              _buildSettingsItem(
                context,
                icon: Icons.info_outline,
                title: appLocalizations.translate('about'),
                onTap: () {
                  // TODO: Implement about section
                },
              ),
            ],
          );
        },
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
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
} 