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
  String get confirmation_failed {
    return Intl.message(
      '',
      name: 'confirmation_failed',
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
  String get transmit {
    return Intl.message(
      '',
      name: 'transmit',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get to_coach {
    return Intl.message(
      '',
      name: 'to_coach',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get whatsapp_exeption {
    return Intl.message(
      '',
      name: 'whatsapp_exeption',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get empty_customers {
    return Intl.message(
      '',
      name: 'empty_customers',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get empty_customers_short {
    return Intl.message(
      '',
      name: 'empty_customers_short',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get change_password {
    return Intl.message(
      '',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get changing_password {
    return Intl.message(
      '',
      name: 'changing_password',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get save_edits {
    return Intl.message(
      '',
      name: 'save_edits',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get description_changing_password {
    return Intl.message(
      '',
      name: 'description_changing_password',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get new_password {
    return Intl.message(
      '',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get new_password_again {
    return Intl.message(
      '',
      name: 'new_password_again',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get passwords_do_not_match {
    return Intl.message(
      '',
      name: 'passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get repeat_input {
    return Intl.message(
      '',
      name: 'repeat_input',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get password_not_changed {
    return Intl.message(
      '',
      name: 'password_not_changed',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get data_entered_incorrectly {
    return Intl.message(
      '',
      name: 'data_entered_incorrectly',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get least_three_characters {
    return Intl.message(
      '',
      name: 'least_three_characters',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get notifications {
    return Intl.message(
      '',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get no_internet_access {
    return Intl.message(
      '',
      name: 'no_internet_access',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get data_download_failed {
    return Intl.message(
      '',
      name: 'data_download_failed',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get server_navailable {
    return Intl.message(
      '',
      name: 'server_navailable',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get failed_update_list {
    return Intl.message(
      '',
      name: 'failed_update_list',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get authorization_failed {
    return Intl.message(
      '',
      name: 'authorization_failed',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get sleeping_customers {
    return Intl.message(
      '',
      name: 'sleeping_customers',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get error_transferring_record {
    return Intl.message(
      '',
      name: 'error_transferring_record',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get schedule {
    return Intl.message(
      '',
      name: 'schedule',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get record {
    return Intl.message(
      '',
      name: 'record',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get sign_up_training_session {
    return Intl.message(
      '',
      name: 'sign_up_training_session',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get select_client {
    return Intl.message(
      '',
      name: 'select_client',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get choice_client {
    return Intl.message(
      '',
      name: 'choice_client',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get duration {
    return Intl.message(
      '',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get personal {
    return Intl.message(
      '',
      name: 'personal',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get split {
    return Intl.message(
      '',
      name: 'split',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get service {
    return Intl.message(
      '',
      name: 'service',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get date_event {
    return Intl.message(
      '',
      name: 'date_event',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get time_lesson {
    return Intl.message(
      '',
      name: 'time_lesson',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get enter_full_number {
    return Intl.message(
      '',
      name: 'enter_full_number',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get client_not_found {
    return Intl.message(
      '',
      name: 'client_not_found',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get choice_service {
    return Intl.message(
      '',
      name: 'choice_service',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get fill_previous_fields {
    return Intl.message(
      '',
      name: 'fill_previous_fields',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get fill_all_fields {
    return Intl.message(
      '',
      name: 'fill_all_fields',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get to_practice {
    return Intl.message(
      '',
      name: 'to_practice',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get back {
    return Intl.message(
      '',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get inactiveCustomers {
    return Intl.message(
      '',
      name: 'inactiveCustomers',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get license_error_title {
    return Intl.message(
      '',
      name: 'license_error_title',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get license_error_body {
    return Intl.message(
      '',
      name: 'license_error_body',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get trining_could_not_recorded {
    return Intl.message(
      '',
      name: 'trining_could_not_recorded',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get trining_could_not_edit {
    return Intl.message(
      '',
      name: 'trining_could_not_edit',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get selected_clients {
    return Intl.message(
      '',
      name: 'selected_clients',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get this_client_supplied {
    return Intl.message(
      '',
      name: 'this_client_supplied',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get activity_could_not_deleted {
    return Intl.message(
      '',
      name: 'activity_could_not_deleted',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get valid_license_not_found {
    return Intl.message(
      '',
      name: 'valid_license_not_found',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get not_find_client {
    return Intl.message(
      '',
      name: 'not_find_client',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get cancel_workout {
    return Intl.message(
      '',
      name: 'cancel_workout',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get revoke {
    return Intl.message(
      '',
      name: 'revoke',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get only_add_or_remove_clients {
    return Intl.message(
      '',
      name: 'only_add_or_remove_clients',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get no_services_found {
    return Intl.message(
      '',
      name: 'no_services_found',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get save {
    return Intl.message(
      '',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get add_least_one_client {
    return Intl.message(
      '',
      name: 'add_least_one_client',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get appointment_has_already_been_held {
    return Intl.message(
      '',
      name: 'appointment_has_already_been_held',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get sales {
    return Intl.message(
      '',
      name: 'sales',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get group {
    return Intl.message(
      '',
      name: 'group',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get expose {
    return Intl.message(
      '',
      name: 'expose',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get expose_sell {
    return Intl.message(
      '',
      name: 'expose_sell',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get quantity {
    return Intl.message(
      '',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get personalka {
    return Intl.message(
      '',
      name: 'personalka',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get extension_sale {
    return Intl.message(
      '',
      name: 'extension_sale',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get starting {
    return Intl.message(
      '',
      name: 'starting',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get amount {
    return Intl.message(
      '',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get choose {
    return Intl.message(
      '',
      name: 'choose',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get choose_service {
    return Intl.message(
      '',
      name: 'choose_service',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get services {
    return Intl.message(
      '',
      name: 'services',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get packages {
    return Intl.message(
      '',
      name: 'packages',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get currency_symbol {
    return Intl.message(
      '',
      name: 'currency_symbol',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get set_duration {
    return Intl.message(
      '',
      name: 'set_duration',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get add_sale {
    return Intl.message(
      '',
      name: 'add_sale',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get for_customer {
    return Intl.message(
      '',
      name: 'for_customer',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get add_sale_failed {
    return Intl.message(
      '',
      name: 'add_sale_failed',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get train {
    return Intl.message(
      '',
      name: 'train',
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
