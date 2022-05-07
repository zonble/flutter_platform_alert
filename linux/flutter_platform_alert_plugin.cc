#include "include/flutter_platform_alert/flutter_platform_alert_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <libintl.h>
#include <sys/utsname.h>

#include <cstring>

#define _(String) gettext(String)

const char kBadArgumentsError[] = "Bad Arguments";

#define FLUTTER_PLATFORM_ALERT_PLUGIN(obj)                                     \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), flutter_platform_alert_plugin_get_type(), \
                              FlutterPlatformAlertPlugin))

struct _FlutterPlatformAlertPlugin {
  GObject parent_instance;
  GtkWidget *parent_window;
  gboolean window_visible;
};

G_DEFINE_TYPE(FlutterPlatformAlertPlugin, flutter_platform_alert_plugin,
              g_object_get_type())

FlValue *get_value(FlValue *args, const char *name, GError **error) {
  if (fl_value_get_type(args) != FL_VALUE_TYPE_MAP) {
    g_set_error(error, 0, 0, "Argument map missing or malformed");
    return nullptr;
  }
  FlValue *value = fl_value_lookup_string(args, name);
  if (value == nullptr) {
    g_set_error(error, 0, 0, "Missing argument.");
    return nullptr;
  }
  return value;
}

static gchar *get_string_value(FlValue *args, const char *name,
                               GError **error) {
  FlValue *value = get_value(args, name, error);
  if (value != nullptr) {
    return g_strdup(fl_value_get_string(value));
  }
  return nullptr;
}

static int64_t get_int_value(FlValue *args, const char *name, GError **error) {
  FlValue *value = get_value(args, name, error);
  if (value != nullptr) {
    return fl_value_get_int(value);
  }
  return 0;
}

static const int PLUGIN_ABORT = -100;
static const int PLUGIN_RETRY = -101;
static const int PLUGIN_IGNORE = -102;
static const int PLUGIN_TRY_AGAIN = -103;
static const int PLUGIN_CONTINUE = -104;

static const int PLUGIN_POSITIVE = -200;
static const int PLUGIN_NEGATIVE = -201;
static const int PLUGIN_NEUTRAL = -202;

// Maps the GTK alert type to the alert type sent from Flutter. Actually the
// alert type is from Windows.
static GtkMessageType message_type_from_string(const char *string) {
  GtkMessageType messageType = GTK_MESSAGE_OTHER;

  if (string == nullptr) {
    messageType = GTK_MESSAGE_OTHER;
  } else if (strcmp(string, "error") == 0 || strcmp(string, "hand") == 0 ||
             strcmp(string, "stop") == 0) {
    messageType = GTK_MESSAGE_ERROR;
  } else if (strcmp(string, "exclamation") == 0 ||
             strcmp(string, "warning") == 0) {
    messageType = GTK_MESSAGE_WARNING;
  } else if (strcmp(string, "information") == 0 ||
             strcmp(string, "asterisk") == 0) {
    messageType = GTK_MESSAGE_INFO;
  } else if (strcmp(string, "question") == 0) {
    messageType = GTK_MESSAGE_QUESTION;
  }
  return messageType;
}

// Shows a standard alert.
static FlMethodResponse *show_alert(FlutterPlatformAlertPlugin *self,
                                    FlMethodCall *method_call) {
  FlValue *args = fl_method_call_get_args(method_call);

  g_autoptr(GError) error = nullptr;
  g_autofree gchar *window_title =
      get_string_value(args, "windowTitle", &error);
  if (window_title == nullptr) {
    return FL_METHOD_RESPONSE(fl_method_error_response_new(
        kBadArgumentsError, error->message, nullptr));
  }
  g_autofree gchar *text = get_string_value(args, "text", &error);
  if (text == nullptr) {
    return FL_METHOD_RESPONSE(fl_method_error_response_new(
        kBadArgumentsError, error->message, nullptr));
  }

  g_autofree gchar *alert_style = get_string_value(args, "alertStyle", &error);
  g_autofree gchar *icon_style = get_string_value(args, "iconStyle", &error);
  int windowPosition = get_int_value(args, "position", &error);

  GtkMessageType messageType = message_type_from_string(icon_style);

  GtkDialogFlags flags = (GtkDialogFlags)(GTK_DIALOG_DESTROY_WITH_PARENT);
  GtkWindow *window = (GtkWindow *)self->parent_window;
  if (!self->window_visible || windowPosition == 1) {
    window = NULL;
  }
  GtkWidget *dialog = gtk_message_dialog_new(
      window, flags, messageType, GTK_BUTTONS_NONE, window_title, NULL);

  gtk_message_dialog_format_secondary_text(GTK_MESSAGE_DIALOG(dialog), text,
                                           NULL);

  if (alert_style == nullptr) {
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_OK"), GTK_RESPONSE_OK);
  } else if (strcmp(alert_style, "abortRetryIgnore") == 0) {
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_Abort"), PLUGIN_ABORT);
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_Retry"), PLUGIN_RETRY);
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_Ignore"), PLUGIN_IGNORE);
  } else if (strcmp(alert_style, "cancelTryContinue") == 0) {
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_Cancel"),
                          GTK_RESPONSE_CANCEL);
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("Try _Again"),
                          PLUGIN_TRY_AGAIN);
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_Continue"), PLUGIN_CONTINUE);
  } else if (strcmp(alert_style, "okCancel") == 0) {
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_OK"), GTK_RESPONSE_OK);
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_Cancel"),
                          GTK_RESPONSE_CANCEL);
  } else if (strcmp(alert_style, "retryCancel") == 0) {
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_Retry"), PLUGIN_RETRY);
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_Cancel"),
                          GTK_RESPONSE_CANCEL);
  } else if (strcmp(alert_style, "yesNo") == 0) {
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_Yes"), GTK_RESPONSE_YES);
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_No"), GTK_RESPONSE_NO);
  } else if (strcmp(alert_style, "yesNoCancel") == 0) {
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_Yes"), GTK_RESPONSE_YES);
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_No"), GTK_RESPONSE_NO);
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_Cancel"),
                          GTK_RESPONSE_CANCEL);
  } else {
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_OK"), GTK_RESPONSE_OK);
  }

  gint selectedButton = gtk_dialog_run(GTK_DIALOG(dialog));
  gtk_widget_destroy(dialog);

  const char *string = nullptr;
  switch (selectedButton) {
  case PLUGIN_ABORT:
    string = "abort";
    break;
  case PLUGIN_RETRY:
    string = "retry";
    break;
  case PLUGIN_IGNORE:
    string = "ignore";
    break;
  case PLUGIN_TRY_AGAIN:
    string = "try_again";
    break;
  case PLUGIN_CONTINUE:
    string = "continue";
    break;
  case GTK_RESPONSE_NONE:
    string = "none";
    break;
  case GTK_RESPONSE_REJECT:
    string = "reject";
    break;
  case GTK_RESPONSE_ACCEPT:
    string = "accept";
    break;
  case GTK_RESPONSE_DELETE_EVENT:
    string = "delete_event";
    break;
  case GTK_RESPONSE_OK:
    string = "ok";
    break;
  case GTK_RESPONSE_CANCEL:
    string = "cancel";
    break;
  case GTK_RESPONSE_CLOSE:
    string = "close";
    break;
  case GTK_RESPONSE_YES:
    string = "yes";
    break;
  case GTK_RESPONSE_NO:
    string = "no";
    break;
  case GTK_RESPONSE_APPLY:
    string = "apply";
    break;
  case GTK_RESPONSE_HELP:
    string = "help";
    break;
  default:
    string = "ok";
    break;
  }

  FlValue *value = fl_value_new_string(string);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(value));
}

// Shows a custom alert.
static FlMethodResponse *show_custom_alert(FlutterPlatformAlertPlugin *self,
                                           FlMethodCall *method_call) {
  FlValue *args = fl_method_call_get_args(method_call);

  g_autoptr(GError) error = nullptr;
  g_autofree gchar *window_title =
      get_string_value(args, "windowTitle", &error);
  if (window_title == nullptr) {
    return FL_METHOD_RESPONSE(fl_method_error_response_new(
        kBadArgumentsError, error->message, nullptr));
  }
  g_autofree gchar *text = get_string_value(args, "text", &error);
  if (text == nullptr) {
    return FL_METHOD_RESPONSE(fl_method_error_response_new(
        kBadArgumentsError, error->message, nullptr));
  }

  g_autofree gchar *icon_style = get_string_value(args, "iconStyle", &error);
  g_autofree gchar *positive_button =
      get_string_value(args, "positiveButtonTitle", &error);
  g_autofree gchar *negative_button =
      get_string_value(args, "negativeButtonTitle", &error);
  g_autofree gchar *neutral_button =
      get_string_value(args, "neutralButtonTitle", &error);
  int windowPosition = get_int_value(args, "position", &error);

  GtkMessageType messageType = message_type_from_string(icon_style);

  GtkDialogFlags flags = (GtkDialogFlags)(GTK_DIALOG_DESTROY_WITH_PARENT);

  GtkWindow *window = (GtkWindow *)self->parent_window;
  if (!self->window_visible || windowPosition == 1) {
    window = NULL;
  }

  GtkWidget *dialog = gtk_message_dialog_new(
      window, flags, messageType, GTK_BUTTONS_NONE, window_title, NULL);
  gtk_message_dialog_format_secondary_text(GTK_MESSAGE_DIALOG(dialog), text,
                                           NULL);

  g_autofree gchar *icon_path = get_string_value(args, "iconPath", &error);

  if (icon_path != nullptr) {
    // gtk_message_dialog_set_image is already deprecated but let us just
    // continue use it today.
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    GtkWidget *image = gtk_image_new_from_file(icon_path);
    gtk_widget_show(image);
    gtk_message_dialog_set_image(GTK_MESSAGE_DIALOG(dialog), image);
#pragma GCC diagnostic pop
  }

  int button_count = 0;
  if (strlen(positive_button)) {
    gtk_dialog_add_button(GTK_DIALOG(dialog), positive_button, PLUGIN_POSITIVE);
    button_count++;
  }
  if (strlen(neutral_button)) {
    gtk_dialog_add_button(GTK_DIALOG(dialog), neutral_button, PLUGIN_NEUTRAL);
    button_count++;
  }
  if (strlen(negative_button)) {
    gtk_dialog_add_button(GTK_DIALOG(dialog), negative_button, PLUGIN_NEGATIVE);
    button_count++;
  }
  if (!button_count) {
    gtk_dialog_add_button(GTK_DIALOG(dialog), _("_OK"), PLUGIN_NEGATIVE);
  }

  gint selectedButton = gtk_dialog_run(GTK_DIALOG(dialog));
  gtk_widget_destroy(dialog);

  const char *string = nullptr;
  switch (selectedButton) {
  case PLUGIN_POSITIVE:
    string = "positive_button";
    break;
  case PLUGIN_NEGATIVE:
    string = "negative_button";
    break;
  case PLUGIN_NEUTRAL:
    string = "neutral_button";
    break;
  default:
    string = "other";
    break;
  }

  FlValue *value = fl_value_new_string(string);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(value));
}

static void flutter_platform_alert_plugin_handle_method_call(
    FlutterPlatformAlertPlugin *self, FlMethodCall *method_call) {

  const gchar *method = fl_method_call_get_name(method_call);

  g_autoptr(FlMethodResponse) response = nullptr;

  if (strcmp(method, "playAlertSound") == 0) {
    gtk_widget_error_bell((GtkWidget *)self->parent_window);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
  } else if (strcmp(method, "showAlert") == 0) {
    response = show_alert(self, method_call);
  } else if (strcmp(method, "showCustomAlert") == 0) {
    response = show_custom_alert(self, method_call);
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }
  fl_method_call_respond(method_call, response, nullptr);
}

static void flutter_platform_alert_plugin_dispose(GObject *object) {
  G_OBJECT_CLASS(flutter_platform_alert_plugin_parent_class)->dispose(object);
}

static void flutter_platform_alert_plugin_class_init(
    FlutterPlatformAlertPluginClass *klass) {
  G_OBJECT_CLASS(klass)->dispose = flutter_platform_alert_plugin_dispose;
}

static void
flutter_platform_alert_plugin_init(FlutterPlatformAlertPlugin *self) {}

static void method_call_cb(FlMethodChannel *channel, FlMethodCall *method_call,
                           gpointer user_data) {
  FlutterPlatformAlertPlugin *plugin = FLUTTER_PLATFORM_ALERT_PLUGIN(user_data);
  flutter_platform_alert_plugin_handle_method_call(plugin, method_call);
}

gboolean callback_func(GtkWidget *widget, GdkEventWindowState *event,
                       gpointer user_data) {
  FlutterPlatformAlertPlugin *plugin = (FlutterPlatformAlertPlugin *)user_data;

  plugin->window_visible =
      !((event->new_window_state & GDK_WINDOW_STATE_ICONIFIED) ||
        (event->new_window_state & GDK_WINDOW_STATE_WITHDRAWN));

  return TRUE;
}

void flutter_platform_alert_plugin_register_with_registrar(
    FlPluginRegistrar *registrar) {
  GtkWidget *toplevel = gtk_widget_get_toplevel(
      (GtkWidget *)fl_plugin_registrar_get_view(registrar));
  FlutterPlatformAlertPlugin *plugin = FLUTTER_PLATFORM_ALERT_PLUGIN(
      g_object_new(flutter_platform_alert_plugin_get_type(), nullptr));
  plugin->parent_window = toplevel;

  g_signal_connect(G_OBJECT(toplevel), "window-state-event",
                   G_CALLBACK(callback_func), plugin);

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "flutter_platform_alert", FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(
      channel, method_call_cb, g_object_ref(plugin), g_object_unref);

  g_object_unref(plugin);
}
