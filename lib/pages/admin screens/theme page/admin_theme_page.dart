import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneak_peak/utils/app%20theme/app_theme.dart';
import 'package:sneak_peak/widgets/admin%20app%20bar/transparent_app_bar.dart';
import 'package:sneak_peak/widgets/list%20tile%20widget/list_tile_widget.dart';

class ThemePage extends ConsumerStatefulWidget {
  const ThemePage({super.key});
  static const pageName = 'theme_page';

  @override
  ConsumerState<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends ConsumerState<ThemePage> {
  String darkModeValue = 'dark_mode';
  String lightModeValue = 'light_mode';
  String systemValue = 'system';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: transparentAppBar(
        title: 'Theme',
        context: context,
        leadingOnTap: () {
          GoRouter.of(context).pop();
        },
        leadingIcon: CupertinoIcons.back,
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Consumer(
              builder: (context, darkRef, child) {
                return ListTileWidget(
                  leadingIcon: Icons.dark_mode,
                  title: 'Dark mode',
                  onTap: () {
                    ref.read(themeProvider.notifier).onChanged(darkModeValue);
                  },
                  trailing: Radio(
                    value: darkModeValue,
                    groupValue: darkRef.watch(themeProvider).groupValue,
                    onChanged: (value) {
                      ref.read(themeProvider.notifier).onChanged(value!);
                    },
                  ),
                );
              },
            ),

            Consumer(
              builder: (context, lightRef, child) {
                return ListTileWidget(
                  leadingIcon: Icons.light_mode,
                  title: 'Light mode',
                  onTap: () {
                    ref.read(themeProvider.notifier).onChanged(lightModeValue);
                  },
                  trailing: Radio(
                    value: lightModeValue,
                    groupValue: lightRef.watch(themeProvider).groupValue,
                    onChanged: (value) {
                      ref.read(themeProvider.notifier).onChanged(value!);
                    },
                  ),
                );
              },
            ),

            Consumer(
              builder: (context, systemRef, child) {
                return ListTileWidget(
                  leadingIcon: Icons.mobile_screen_share,
                  title: 'System',
                  onTap: () {
                    ref.read(themeProvider.notifier).onChanged(systemValue);
                  },
                  trailing: Radio(
                    value: systemValue,
                    groupValue: systemRef.watch(themeProvider).groupValue,
                    onChanged:
                        (value) =>
                            ref.read(themeProvider.notifier).onChanged(value!),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

final themeProvider = StateNotifierProvider<ThemeStateNotifier, ThemeClass>((
  ref,
) {
  return ThemeStateNotifier();
});

class ThemeStateNotifier extends StateNotifier<ThemeClass> {
  ThemeStateNotifier()
    : super(ThemeClass(groupValue: 'light_mode', themeData: lightTheme));

  Future<void> getTheme() async {
    var sp = await SharedPreferences.getInstance();

    var currentTheme = sp.getString('theme') ?? 'light_mode';

    if (currentTheme == 'light_mode') {
      state = state.copyWith(groupvalueX: 'light_mode', themeDataX: lightTheme);
    } else if (currentTheme == 'dark_mode') {
      state = state.copyWith(groupvalueX: 'dark_mode', themeDataX: darkTheme);
    } else {
      state = state.copyWith(groupvalueX: 'system');
    }
  }

  Future<void> onChanged(String groupvalue) async {
    var sp = await SharedPreferences.getInstance();
    state = state.copyWith(groupvalueX: groupvalue);
    sp.setString('theme', groupvalue);
    if (groupvalue == 'light_mode') {
      state = state.copyWith(themeDataX: lightTheme);
    } else {
      state = state.copyWith(themeDataX: darkTheme);
    }
  }
}

class ThemeClass {
  final String groupValue;
  final ThemeData themeData;
  const ThemeClass({required this.groupValue, required this.themeData});

  ThemeClass copyWith({String? groupvalueX, ThemeData? themeDataX}) {
    return ThemeClass(
      groupValue: groupvalueX ?? groupValue,
      themeData: themeDataX ?? themeData,
    );
  }
}
