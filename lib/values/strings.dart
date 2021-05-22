// ignore_for_file: prefer_single_quotes, always_specify_types
// Ignoring some lint rules because I want the map to also be valid json.

class Strings {
  Map<String, Map<String, String>> map = <String, Map<String, String>> {
    "home_title": {
      "en": "Home",
      "pt": "Início"
    },
    "login_title": {
      "en": "Login",
      "pt": "Entrar"
    },
    "login_email": {
      "en": "Email",
      "pt": "E-mail"
    },
    "login_password": {
      "en": "Password",
      "pt": "Senha"
    },
    "login_error_bad_credentials": {
      "en": "Wrong email or password.",
      "pt": "E-mail ou senha incorreta."
    },
    "login_semantics_password_visibility_toggle": {
      "en": "Password visibility toggle",
      "pt": "Toggle de visibilidade da senha"
    },
    "login_semantics_password_hide": {
      "en": "Hide password",
      "pt": "Ocultar senha"
    },
    "login_semantics_password_reveal": {
      "en": "Make password visible",
      "pt": "Tornar senha visível"
    },
    "login_try_these_creds": {
      "en": "Try email \"eve.holt@reqres.in\" and any password",
      "pt": "Tente o email \"eve.holt@reqres.in\" e qualquer senha"
    },
    "login_welcome": {
      "en": "Welcome 👋",
      "pt": "Seja bem-vindo 👋"
    },
    "logout_confirmation_title": {
      "en": "Logout?",
      "pt": "Sair?"
    },
    "logout_confirmation": {
      "en": "Logout",
      "pt": "Sair"
    },
    "common_cancel": {
      "en": "Cancel",
      "pt": "Cancelar"
    },
    "common_error_server_generic": {
      "en": "Something went wrong. Please try again.",
      "pt": "Algo deu errado. Por favor, tente novamente."
    },
    "common_ok": {
      "en": "Ok",
      "pt": "Ok"
    },
    "validation_message_email_required": {
      "en": "Email required",
      "pt": "E seu e-mail?"
    },
    "validation_message_email_invalid": {
      "en": "Please inform a valid e-mail",
      "pt": "Favor informar um e-mail válido"
    },
    "validation_message_password_required": {
      "en": "Password required",
      "pt": "E a senha?"
    },
    "validation_message_password_too_short": {
      "en": "Password must be 6 characters or more",
      "pt": "Senha deve ter no mínimo 6 caracteres"
    }
  };
}
