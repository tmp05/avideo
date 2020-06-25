library constants;

import 'dart:ui';
import 'package:flutter/material.dart';

class Constants {
  static const Color darkBlueColor = Color(0xFF42A5F5);
  static const Color lightBlueColor = Color(0xFF90CAF9);
  static const Color blackColor = Colors.black;
  static const Color whiteColor = Colors.white;
  static const Color errorColor = Colors.redAccent;
  static const Color greenColor = Colors.green;
  static const Color grayColor = Color(0xFFA1A1A1);
  static const Color orangeColor = Colors.deepOrange;
  static const Color alertColor = Colors.red;

  static const TextStyle Style18Text = TextStyle( fontSize: 18.0, color: whiteColor, fontWeight: FontWeight.bold);
  static const TextStyle Style14Text = TextStyle( fontSize: 14.0, color: whiteColor, fontWeight: FontWeight.bold);
  static const TextStyle StyleTextSeries = TextStyle( fontSize: 16.0, color: whiteColor,fontWeight: FontWeight.bold);
  static const TextStyle StyleTextUnderline = TextStyle( fontSize: 16.0, color: whiteColor,fontWeight: FontWeight.bold, decoration: TextDecoration.underline);
  static const TextStyle StyleFilterText = TextStyle( fontSize: 16.0, color: blackColor,fontWeight: FontWeight.bold);
  static const TextStyle StyleFilterTextUnderline = TextStyle( fontSize: 16.0, color: blackColor,fontWeight: FontWeight.bold, decoration: TextDecoration.underline);
  static const TextStyle StyleAlertFilterTextUnderline = TextStyle( fontSize: 16.0, color: alertColor,fontWeight: FontWeight.bold, decoration: TextDecoration.underline);
  static const TextStyle StyleNoFilterTextUnderline = TextStyle( fontSize: 16.0, color: greenColor,fontWeight: FontWeight.bold, decoration: TextDecoration.underline);

  static const String enterText = 'Вход';
  static const String exitText = 'Выход';
  static const String enter2Text = 'ВОЙТИ';
  static const String emailText = 'Email';
  static const String passwordText = 'Пароль';
  static const String changePasswordText = 'Изменить пароль';
  static const String errorRequest = 'Ошибка запроса';
  static const String filmText = 'ФИЛЬМЫ';
  static const String serialText = 'СЕРИАЛЫ';
  static const String animeText = 'АНИМЕ';
  static const String customText = 'настройки';
  static const String sortText = 'Сортировка';
  static const String okText = 'OK';
  static const String yearText = 'Год';

  static const String fieldIsNecessaryText ='Это поле обязательно для выполнения';
  static const String emailIsNecessaryText ='Без email авторизация невозможна';
  static const String promoIsWrongText ='Промокод не найден';
  static const String promoRequiredText ='Не обязателен для заполнения';

  static const String emailIsWrongText ='Пожалуйста, введите корректный email';
  static const String recoverPasswordText ='ВОССТАНОВИТЬ ПАРОЛЬ';
  static const String registerText ='ЗАРЕГИСТРИРОВАТЬСЯ';
  static const String registrationText ='Регистрация';
  static const String promoText ='Промокод';
  static const String acceptText ='ПРИНЯТЬ';
  static const String restoreText = 'Восстановление пароля';
  static const String backText = 'Назад';
  static const String emailIsSentText = 'Письмо отправлено на вашу почту.';
  static const String errorRestoreText = 'Ошибка восстановления пароля';
  static const String errorAuthText = 'Ошибка авторизации';
  static const String verificationText = 'Ваша учетная запись не активирована. Если вам не пришло на почту письмо активации, нажмите ';
  static const String resendEmail = 'Отправлено повторное письмо активации';
  static const String saveText = 'СОХРАНИТЬ';
  static const String saveDataText ='Ваши данные сохранены';
  static const String errorPassText ='Ошибка смены пароля';
  static const String errorAccess ='Ошибка доступа';
  static const String profileMenuText = 'Профиль';
  static const String payMenuText = 'Оплата доступа';
  static const String referalMenuText = 'Реферальная система';
  static const String devicesMenuText = 'Привязка устройств';
  static const String listFilterText = 'Настройка списка';

  static const String genreFilterText = 'Жанр';
  static const String genreTitleFilterText = 'Выберите жанры';
  static const String studioTitleFilterText = 'Выберите киностудии';
  static const String studioFilterText = 'Киностудии';

  static const List<Item> items = <Item>[
    Item(Constants.profileMenuText,Icon(Icons.person)),
    Item(Constants.payMenuText,Icon(Icons.credit_card)),
    Item(Constants.exitText,Icon(Icons.exit_to_app)),
  ];

  static const List<SortItem> sortItems = <SortItem>[
    SortItem('по просмотрам',''),
    SortItem('по просмотрам за все время','top'),
    SortItem('по обновлению','fresh'),
    SortItem('по дате добавления','last'),
    SortItem('по рейтингу кинопоиска','kinopoisk'),
    SortItem('по рейтингу IMDB','imdb'),
  ];
}

class Item {
  const Item(this.name,this.icon);
  final String name;
  final Icon icon;
}

class SortItem {
  const SortItem(this.name,this.id);
  final String name;
  final String id;
}

