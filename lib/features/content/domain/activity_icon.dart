//lib\features\content\domain\activity_icon.dart

enum ActivityIcon { quickTask, coding, audit, toolkit, boss }

extension ActivityIconAsset on ActivityIcon {
  String get assetPath {
    switch (this) {
      case ActivityIcon.quickTask:
        return 'assets/tea.svg';
      case ActivityIcon.coding:
        return 'assets/pc_escritorio.svg';
      case ActivityIcon.audit:
        return 'assets/lupa.svg';
      case ActivityIcon.toolkit:
        return 'assets/toolbox.svg';
      case ActivityIcon.boss:
        return 'assets/boss.svg';
    }
  }
}