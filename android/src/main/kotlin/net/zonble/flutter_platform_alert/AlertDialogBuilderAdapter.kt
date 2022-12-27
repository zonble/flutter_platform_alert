package net.zonble.flutter_platform_alert

import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import android.graphics.drawable.Drawable

class AlertDialogBuilderAdapter(context: Context) : IDialogBuilderAdapter {
  private val builder: AlertDialog.Builder

  init {
    builder = AlertDialog.Builder(context, R.style.AlertDialogCustom)
  }

  override fun setTitle(title: CharSequence): IDialogBuilderAdapter {
    builder.setTitle(title)
    return this
  }

  override fun setMessage(message: CharSequence): IDialogBuilderAdapter {
    builder.setTitle(message)
    return this
  }

  override fun setPositiveButton(
    text: CharSequence,
    listener: DialogInterface.OnClickListener,
  ): IDialogBuilderAdapter {
    builder.setPositiveButton(text, listener)
    return this
  }

  override fun setPositiveButton(
    textId: Int,
    listener: DialogInterface.OnClickListener,
  ): IDialogBuilderAdapter {
    builder.setPositiveButton(textId, listener)
    return this
  }

  override fun setNegativeButton(
    text: CharSequence,
    listener: DialogInterface.OnClickListener,
  ): IDialogBuilderAdapter {
    builder.setNegativeButton(text, listener)
    return this
  }

  override fun setNegativeButton(
    textId: Int,
    listener: DialogInterface.OnClickListener,
  ): IDialogBuilderAdapter {
    builder.setNegativeButton(textId, listener)
    return this
  }

  override fun setNeutralButton(
    text: CharSequence,
    listener: DialogInterface.OnClickListener,
  ): IDialogBuilderAdapter {
    builder.setNegativeButton(text, listener)
    return this
  }

  override fun setNeutralButton(
    textId: Int,
    listener: DialogInterface.OnClickListener,
  ): IDialogBuilderAdapter {
    builder.setNegativeButton(textId, listener)
    return this
  }

  override fun setIcon(icon: Drawable): IDialogBuilderAdapter {
    builder.setIcon(icon)
    return this
  }

  override fun createAndShow() = builder.create().show()
}