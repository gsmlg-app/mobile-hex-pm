import 'package:flutter/material.dart';
import 'package:settings_ui/src/tiles/abstract_settings_tile.dart';
import 'package:settings_ui/src/tiles/platforms/android_settings_tile.dart';
import 'package:settings_ui/src/tiles/platforms/ios_settings_tile.dart';
import 'package:settings_ui/src/tiles/platforms/web_settings_tile.dart';
import 'package:settings_ui/src/utils/platform_utils.dart';
import 'package:settings_ui/src/utils/settings_theme.dart';

enum SettingsTileType { simpleTile, switchTile, navigationTile, checkTile }

class SettingsTile extends AbstractSettingsTile {
  SettingsTile({
    this.leading,
    this.trailing,
    this.value,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    super.key,
  }) {
    onToggle = null;
    initialValue = null;
    activeSwitchColor = null;
    checked = null;
    tileType = SettingsTileType.simpleTile;
  }

  SettingsTile.navigation({
    this.leading,
    this.trailing,
    this.value,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    super.key,
  }) {
    onToggle = null;
    initialValue = null;
    activeSwitchColor = null;
    checked = null;
    tileType = SettingsTileType.navigationTile;
  }

  SettingsTile.switchTile({
    required this.initialValue,
    required this.onToggle,
    this.activeSwitchColor,
    this.leading,
    this.trailing,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    super.key,
  }) {
    value = null;
    checked = null;
    tileType = SettingsTileType.switchTile;
  }

  SettingsTile.checkTile({
    this.leading,
    this.trailing,
    this.value,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    this.checked,
    super.key,
  }) {
    onToggle = null;
    initialValue = null;
    activeSwitchColor = null;
    tileType = SettingsTileType.checkTile;
  }

  /// The widget at the beginning of the tile
  final Widget? leading;

  /// The Widget at the end of the tile
  final Widget? trailing;

  /// The widget at the center of the tile
  final Widget title;

  /// The widget at the bottom of the [title]
  final Widget? description;

  /// A function that is called by tap on a tile
  final void Function(BuildContext context)? onPressed;

  late final Color? activeSwitchColor;
  late final Widget? value;
  late final Function(bool value)? onToggle;
  late final SettingsTileType tileType;
  late final bool? initialValue;
  late final bool enabled;
  late final bool? checked;

  Widget? addCheckedTrailing(BuildContext context) {
    if (checked != null) {
      return checked!
          ? const Icon(
              Icons.check,
              color: Colors.lightGreen,
            )
          : const Icon(
              Icons.check,
              color: Colors.transparent,
            );
    }
    return trailing;
  }

  @override
  Widget build(BuildContext context) {
    final theme = SettingsTheme.of(context);

    switch (theme.platform) {
      case DevicePlatform.android:
      case DevicePlatform.fuchsia:
      case DevicePlatform.linux:
        return AndroidSettingsTile(
          description: description,
          onPressed: onPressed,
          onToggle: onToggle,
          tileType: tileType,
          value: value,
          leading: leading,
          title: title,
          enabled: enabled,
          activeSwitchColor: activeSwitchColor,
          initialValue: initialValue ?? false,
          trailing: addCheckedTrailing(context),
        );
      case DevicePlatform.iOS:
      case DevicePlatform.macOS:
      case DevicePlatform.windows:
        return IOSSettingsTile(
          description: description,
          onPressed: onPressed,
          onToggle: onToggle,
          tileType: tileType,
          value: value,
          leading: leading,
          title: title,
          trailing: addCheckedTrailing(context),
          enabled: enabled,
          activeSwitchColor: activeSwitchColor,
          initialValue: initialValue ?? false,
        );
      case DevicePlatform.web:
      case DevicePlatform.custom:
        return WebSettingsTile(
          description: description,
          onPressed: onPressed,
          onToggle: onToggle,
          tileType: tileType,
          value: value,
          leading: leading,
          title: title,
          enabled: enabled,
          trailing: addCheckedTrailing(context),
          activeSwitchColor: activeSwitchColor,
          initialValue: initialValue ?? false,
        );
    }
  }
}
