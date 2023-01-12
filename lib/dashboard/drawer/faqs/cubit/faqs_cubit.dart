import 'dart:convert';

import 'package:altme/dashboard/dashboard.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';

class FaqsCubit extends Cubit<FaqModel> {
  FaqsCubit() : super(const FaqModel(faq: [])) {
    initialise();
  }

  Future<void> initialise() async {
    final json = await rootBundle.loadString('assets/faq.json');
    final FaqModel faqModel =
        FaqModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
    emit(faqModel);
  }
}
