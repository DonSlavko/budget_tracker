import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.translate('settings')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Theme Mode Selection
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor,
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
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: theme.inputDecorationTheme.fillColor ?? theme.colorScheme.surface.withOpacity(0.1),
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
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            ButtonSegment<ThemeMode>(
                              value: ThemeMode.dark,
                              label: Text(appLocalizations.translate('dark')),
                              icon: Icon(
                                Icons.dark_mode,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            ButtonSegment<ThemeMode>(
                              value: ThemeMode.system,
                              label: Text(appLocalizations.translate('system')),
                              icon: Icon(
                                Icons.settings_suggest,
                                color: theme.colorScheme.primary,
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
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor,
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
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: theme.inputDecorationTheme.fillColor ?? theme.colorScheme.surface.withOpacity(0.1),
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
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            ButtonSegment<String>(
                              value: 'sr',
                              label: Text(appLocalizations.translate('serbian')),
                              icon: Icon(
                                Icons.language,
                                color: theme.colorScheme.primary,
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
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
} 