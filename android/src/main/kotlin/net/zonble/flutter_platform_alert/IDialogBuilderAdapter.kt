package net.zonble.flutter_platform_alert

import android.content.DialogInterface
import android.graphics.drawable.Drawable

interface IDialogBuilderAdapter {
  fun setTitle(title: CharSequence): IDialogBuilderAdapter

  fun setMessage(message: CharSequence): IDialogBuilderAdapter

  fun setPositiveButton(
    text: CharSequence, listener: DialogInterface.OnClickListener,
  ): IDialogBuilderAdapter

  fun setPositiveButton(
    textId: Int,
    listener: DialogInterface.OnClickListener,
  ): IDialogBuilderAdapter

  fun setNegativeButton(
    text: CharSequence, listener: DialogInterface.OnClickListener,
  ): IDialogBuilderAdapter

  fun setNegativeButton(
    textId: Int,
    listener: DialogInterface.OnClickListener,
  ): IDialogBuilderAdapter

  fun setNeutralButton(
    text: CharSequence, listener: DialogInterface.OnClickListener,
  ): IDialogBuilderAdapter

  fun setNeutralButton(
    textId: Int,
    listener: DialogInterface.OnClickListener,
  ): IDialogBuilderAdapter

  fun createAndShow(): Unit
  fun setIcon(icon: Drawable): IDialogBuilderAdapter
}
