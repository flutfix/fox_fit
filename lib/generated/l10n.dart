// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// ``
  String get log_in {
    return Intl.message(
      '',
      name: 'log_in',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get customer_information {
    return Intl.message(
      '',
      name: 'customer_information',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get kickoff_training {
    return Intl.message(
      '',
      name: 'kickoff_training',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get cancel {
    return Intl.message(
      '',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get send_to_trainer {
    return Intl.message(
      '',
      name: 'send_to_trainer',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get confirm {
    return Intl.message(
      '',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get comment_for_recipient {
    return Intl.message(
      '',
      name: 'comment_for_recipient',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get trainer_stats {
    return Intl.message(
      '',
      name: 'trainer_stats',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get support {
    return Intl.message(
      '',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get coordinator {
    return Intl.message(
      '',
      name: 'coordinator',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get log_out {
    return Intl.message(
      '',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get chat {
    return Intl.message(
      '',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get exit {
    return Intl.message(
      '',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get fast_search {
    return Intl.message(
      '',
      name: 'fast_search',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get triner_choosing {
    return Intl.message(
      '',
      name: 'triner_choosing',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get login_exeption {
    return Intl.message(
      '',
      name: 'login_exeption',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get wrong_login_or_pass {
    return Intl.message(
      '',
      name: 'wrong_login_or_pass',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get server_error {
    return Intl.message(
      '',
      name: 'server_error',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get status_not_sent {
    return Intl.message(
      '',
      name: 'status_not_sent',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get error {
    return Intl.message(
      '',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get leave_comment {
    return Intl.message(
      '',
      name: 'leave_comment',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get coordinaor_workspace {
    return Intl.message(
      '',
      name: 'coordinaor_workspace',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
