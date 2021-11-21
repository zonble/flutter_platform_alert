/// Represents the icon that appears in the dialog/alert.
enum IconStyle {
  /// No icon.
  none,

  /// Represents showing a icon for errors.
  ///
  /// - MB_ICONEXCLAMATION on Windows.
  /// - GTK_MESSAGE_WARNING on Linux.
  exclamation,

  /// Represents showing a icon for errors.
  ///
  /// - MB_ICONWARNING on Windows.
  /// - GTK_MESSAGE_WARNING on Linux.
  warning,

  /// Represents showing a icon with a letter "i".
  ///
  /// - MB_ICONINFORMATION on Windows.
  /// - GTK_MESSAGE_INFO on Linux.
  information,

  /// Represents showing a icon with a letter "i".
  ///
  /// - MB_ICONASTERISK on Windows.
  /// - GTK_MESSAGE_INFO on Linux.
  asterisk,

  /// Represents showing a question icon.
  ///
  /// - MB_ICONQUESTION on Windows.
  /// - GTK_MESSAGE_QUESTION on Linux.
  question,

  /// Represents showing a stop or error icon.
  ///
  /// - MB_ICONSTOP on Windows.
  /// - GTK_MESSAGE_ERROR on Linux.
  stop,

  /// Represents showing a stop or error icon.
  ///
  /// - MB_ICONERROR on Windows
  /// - GTK_MESSAGE_ERROR on Linux.
  error,

  /// Represents showing a stop or error icon.
  /// - MB_ICONHAND on Windows.
  /// - GTK_MESSAGE_ERROR on Linux.
  hand,
}

String iconStyleToString(IconStyle style) {
  switch (style) {
    case IconStyle.none:
      return 'none';
    case IconStyle.exclamation:
      return 'exclamation';
    case IconStyle.warning:
      return 'warning';
    case IconStyle.information:
      return 'information';
    case IconStyle.asterisk:
      return 'asterisk';
    case IconStyle.question:
      return 'question';
    case IconStyle.stop:
      return 'stop';
    case IconStyle.error:
      return 'error';
    case IconStyle.hand:
      return 'hand';
  }
}
