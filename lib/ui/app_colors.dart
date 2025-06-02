import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color richBlack = Color(0xFF010B13);
  static const Color gray1 = Color(0xFF484848);
  static const Color gray2 = Color(0xFF797979);
  static const Color gray3 = Color(0xFFA9A9A9);
  static const Color gray4 = Color(0xFFD9D9D9);
  static const Color white = Color(0xFFFFFFFF);

  static const Color backgroundBlack = Color(0xFF393E46);
  static const Color blackBar = Color(0xFF222831);
  static const Color background = Color(0xFFF7F7F7);

  // 다크네이비 계열
  static const Color navy100 = Color(0xFF11182B); // 깊은 네이비
  static const Color navy40 = Color(0xFF92959D); // 중간 네이비
  static const Color navy20 = Color(0xFFB5B7BD); // 연한 네이비
  static const Color navy10 = Color(0xFFE7E8EA); // 아이보리 베이지

  // 올리브 계열
  static const Color olive120 = Color(0xFF5C7285); // 블루 그레이
  static const Color olive100 = Color(0xFF818C78); // 짙은 올리브
  static const Color olive80 = Color(0xFFA7B49E); // 중간 올리브
  static const Color olive60 = Color(0xFFE2E0C8); // 베이지 올리브

  // 파스텔 계열
  static const Color pastel120 = Color(0xFFFAF1E6); // 크림
  static const Color pastel100 = Color(0xFFFDFAF6); // 오프화이트
  static const Color pastel80 = Color(0xFFE4EFE7); // 민트 크림
  static const Color pastel60 = Color(0xFF99BC85); // 연한 라임

  // 그린 계열
  static const Color green120 = Color(0xFFE1EEBC); // 연한 라임 그린
  static const Color green100 = Color(0xFF90C67C); // 중간 라임 그린
  static const Color green80 = Color(0xFF67AE6E); // 중간 초록
  static const Color green60 = Color(0xFF328E6E); // 짙은 에메랄드 그린

  static const Color secondary100 = Color(0xFFFF9C00);
  static const Color secondary80 = Color(0xFFFFA61A);
  static const Color secondary60 = Color(0xFFFFBA4D);
  static const Color secondary40 = Color(0xFFFFCE80);
  static const Color secondary20 = Color(0xFFFFE1B3);

  static const Color rating = Color(0xFFFFAD30);

  static const Color warning = Color(0xFFE94A59);
  static const Color warningLight = Color(0xFFFFE1E7);

  static const Color success = Color(0xFF31B057);

  static const List<Color> selectorColors = [
    navy100,
    navy40,
    navy20,
    navy10,
    olive120,
    olive100,
    olive80,
    olive60,
    pastel120,
    pastel100,
    pastel80,
    pastel60,
    green120,
    green100,
    green80,
    green60,
  ];
}
