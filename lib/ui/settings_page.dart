import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/preferences/preferences_helper.dart';
import 'package:restaurant_app/provider/preferences_provider.dart';
import 'package:restaurant_app/provider/schedulling_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/settings_page';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SchedulingProvider(),
        ),
      ],
      child: _buildScaffold(context),
    );
  }

  Scaffold _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (_, prefProv, __) {
        Widget subtitle;
        if (prefProv.isDailyReminderActive) {
          subtitle = const Text('Non-aktifkan pemberitahuan');
        } else {
          subtitle = const Text('Aktifkan pemberitahuan');
        }

        return ListView(
          children: [
            ListTile(
              title: const Text(
                'Pemberitahuan Rekomendasi Restoran',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: subtitle,
              trailing: Consumer<SchedulingProvider>(
                builder: (_, schedProv, __) {
                  return Switch.adaptive(
                    value: prefProv.isDailyReminderActive,
                    onChanged: (value) async {
                      SnackBar snackBar;
                      Duration duration = const Duration(seconds: 1);

                      if (Platform.isIOS) {
                        snackBar = SnackBar(
                          content: const Text(
                              'Fitur ini belum tersedia untuk IOS, segera hadir!'),
                          duration: duration,
                        );
                      } else {
                        schedProv.setScheduledRestaurantRecommendation(value);
                        prefProv.setDailyReminder(value);

                        if (value) {
                          snackBar = SnackBar(
                            content: const Text(
                                'Penjadwalan pemberitahuan telah diaktifkan!'),
                            duration: duration,
                          );
                        } else {
                          snackBar = SnackBar(
                            content: const Text(
                                'Penjadwalan pemberitahuan telah diberhentikan!'),
                            duration: duration,
                          );
                        }
                      }

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
