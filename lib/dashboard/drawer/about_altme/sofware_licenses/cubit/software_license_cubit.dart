import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'software_license_cubit.g.dart';
part 'software_license_state.dart';

class SoftwareLicenseCubit extends Cubit<SoftwareLicenseState> {
  SoftwareLicenseCubit() : super(SoftwareLicenseState());

  Future<void> initialise() async {
    emit(state.loading());

    final Map<String, List<String>> groupedLicenses = {};

    await for (final license in LicenseRegistry.licenses) {
      final titles = license.packages.toList();

      for (final title in titles) {
        final description = license.paragraphs
            .map<String>((paragraph) => paragraph.text)
            .join('\n\n');

        if (groupedLicenses.containsKey(title)) {
          groupedLicenses[title]!.add(description);
        } else {
          groupedLicenses[title] = [description];
        }
      }
    }

    final licenses = groupedLicenses.entries
        .map((entry) => LicenseModel(entry.key, entry.value))
        .toList();

    licenses.sort(
      (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
    );

    emit(state.copyWith(status: AppStatus.populate, licenses: licenses));
  }
}
