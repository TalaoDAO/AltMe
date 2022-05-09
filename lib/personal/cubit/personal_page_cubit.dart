import 'package:bloc/bloc.dart';

part 'personal_page_state.dart';

class PersonalPgeCubit extends Cubit<PersonalPageState> {
  PersonalPgeCubit() : super(const PersonalPageState());

  void firstNameCheckBoxChange({bool? value}) {
    emit(state.copyWith(isFirstName: value));
  }

  void lastNameCheckBoxChange({bool? value}) {
    emit(state.copyWith(isLastName: value));
  }

  void phoneCheckBoxChange({bool? value}) {
    emit(state.copyWith(isPhone: value));
  }

  void locationCheckBoxChange({bool? value}) {
    emit(state.copyWith(isLocation: value));
  }

  void emailCheckBoxChange({bool? value}) {
    emit(state.copyWith(isEmail: value));
  }

  void companyNameCheckBoxChange({bool? value}) {
    emit(state.copyWith(isCompanyName: value));
  }

  void companyWebsiteCheckBoxChange({bool? value}) {
    emit(state.copyWith(isCompanyWebsite: value));
  }

  void jobTitleCheckBoxChange({bool? value}) {
    emit(state.copyWith(isJobTitle: value));
  }
}
