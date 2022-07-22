import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'search_cubit.g.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required this.repository,
    required this.secureStorageProvider,
  }) : super(SearchState()) {
    initialize();
  }

  final CredentialsRepository repository;
  final SecureStorageProvider secureStorageProvider;

  Future initialize() async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final key = await secureStorageProvider.get(SecureStorageKeys.ssiKey);
    if (key != null) {
      if (key.isNotEmpty) {
        await loadAllCredentialsFromRepository();
      }
    }
    emit(state.copuWith(status: AppStatus.idle));
  }

  Future loadAllCredentialsFromRepository() async {
    await repository.findAll(/* filters */).then((values) {
      /// remove tezosAssociatedWallet
      // values.removeWhere(
      //   (credential) =>
      //       credential.credentialPreview.credentialSubjectModel
      //           .credentialSubjectType ==
      //       CredentialSubjectType.tezosAssociatedWallet,
      // );
      emit(state.populate(credentials: values));
    });
  }

  Future searchWallet(String searchText) async {
    emit(state.loading(searchText: searchText));
    final searchKeywords = searchText.split(' ');

    /// We remove empty strings from the list of keyWords
    searchKeywords.removeWhere((element) => element == '');
    if (searchKeywords.isNotEmpty) {
      await loadAllCredentialsFromRepository();
      final searchList = state.credentials.where((element) {
        var isMatch = false;
        for (final keyword in searchKeywords) {
          if (removeDiacritics(jsonEncode(element))
              .toLowerCase()
              .contains(removeDiacritics(keyword.toLowerCase()))) {
            isMatch = true;
          }
        }
        return isMatch;
      }).toList();
      emit(state.populate(credentials: searchList));
    }
  }

  String removeDiacritics(String str) {
    final diacriticsMap = <dynamic, dynamic>{};

    if (diacriticsMap.isEmpty) {
      for (var i = 0; i < ACCENTUATIONS.length; i++) {
        // ignore: cast_nullable_to_non_nullable
        final letters = ACCENTUATIONS[i]['letters'] as String;
        for (var j = 0; j < letters.length; j++) {
          diacriticsMap[letters[j]] = ACCENTUATIONS[i]['key'];
        }
      }
    }

    return str.replaceAllMapped(
      RegExp('[^\u0000-\u007E]', multiLine: true),
      (a) {
        if (diacriticsMap[a.group(0)] != null) {
          return diacriticsMap[a.group(0)] as String;
        } else {
          // ignore: cast_nullable_to_non_nullable
          return a.group(0) as String;
        }
      },
    );
  }
}
