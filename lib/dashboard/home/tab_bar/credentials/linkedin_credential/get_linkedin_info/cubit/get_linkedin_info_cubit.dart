import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_linkedin_info_cubit.g.dart';
part 'get_linkedin_info_state.dart';

class GetLinkedinInfoCubit extends Cubit<GetLinkedinInfoState> {
  GetLinkedinInfoCubit() : super(const GetLinkedinInfoState());

  void isUrlValid(String value) {
    final RegExp linkedInRegex =
        RegExp(r'^(https:\/\/)(www\.)?linkedin\.com\/in\/[a-zA-Z0-9-]+(\/)?$');

    emit(
      state.copyWith(
        isTextFieldEdited: value.isNotEmpty,
        isLinkedUrlValid: linkedInRegex.hasMatch(value),
      ),
    );
  }
}
