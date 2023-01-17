import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/sofware_licenses/model/license_model.dart';
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
    final List<LicenseModel> licenses =
        await LicenseRegistry.licenses.asyncMap<LicenseModel>((license) async {
      final title = license.packages.join('\n');
      final description = license.paragraphs
          .map<String>((paragraph) => paragraph.text)
          .join('\n\n');

      return LicenseModel(title, description);
    }).toList();
    emit(state.copyWith(status: AppStatus.populate, licenses: licenses));
  }
}
