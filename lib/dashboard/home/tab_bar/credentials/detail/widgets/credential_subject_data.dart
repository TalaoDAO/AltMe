import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/helper_functions/get_display.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_path/json_path.dart';

class CredentialSubjectData extends StatelessWidget {
  const CredentialSubjectData({
    super.key,
    required this.credentialModel,
    required this.showVertically,
  });

  final CredentialModel credentialModel;
  final bool showVertically;

  @override
  Widget build(BuildContext context) {
    final credentialSupported = credentialModel.credentialSupported;

    var credentialSubjectReference = JsonPath(r'$..credentialSubject')
        .read(credentialSupported)
        .firstOrNull
        ?.value;

    if (credentialSubjectReference == null) return Container();
    if (credentialSubjectReference is! Map<String, dynamic>) return Container();

    if (credentialSupported == null) return Container();

    final credentialDefinition = credentialSupported['credential_definition'];

    if (credentialDefinition != null &&
        credentialDefinition is Map<String, dynamic> &&
        credentialDefinition.containsKey('order')) {
      final order = credentialDefinition['order'];

      if (order != null && order is List<dynamic>) {
        final orderList = order.map((dynamic e) => e.toString()).toList();

        final orderedData = <String, dynamic>{};
        final remainingData = <String, dynamic>{};

        // Order elements based on the order list
        for (final key in orderList) {
          if (credentialSubjectReference.containsKey(key)) {
            orderedData[key] = credentialSubjectReference[key];
          }
        }

        // Add remaining elements to the end of the ordered map
        credentialSubjectReference.forEach((key, value) {
          if (!orderedData.containsKey(key)) {
            remainingData[key] = value;
          }
        });

        orderedData.addAll(remainingData);
        credentialSubjectReference = orderedData;
      }
    }

    final credentialSubjectData = credentialModel.data['credentialSubject'];

    if (credentialSubjectData == null) return Container();
    if (credentialSubjectData is! Map<String, dynamic>) return Container();

    final languageCode = context.read<LangCubit>().state.locale.languageCode;
    return displayWidget(
      credentialSubjectReference,
      languageCode,
      credentialSubjectData,
    );
  }

  Widget displayWidget(
    Map<String, dynamic> displayInstructions,
    String languageCode,
    Map<String, dynamic> credentialSubjectData,
  ) {
    final Widget column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          displayInstructions.entries.map((MapEntry<String, dynamic> map) {
        String? title;
        String? data;

        final displayInstructionKey = map.key;
        final displayInstructionValue = map.value;

        if (displayInstructionValue is! Map<String, dynamic>) {
          return const SizedBox.shrink();
        }

        if (displayInstructionValue.containsKey('display')) {
          final display = getDisplay(displayInstructionValue, languageCode);
          if (display == null) return const SizedBox.shrink();

          if (credentialSubjectData.containsKey(displayInstructionKey)) {
            title = display['name'].toString();
            data = credentialSubjectData[displayInstructionKey] is Map ||
                    credentialSubjectData[displayInstructionKey] is List
                ? jsonEncode(credentialSubjectData[displayInstructionKey])
                : credentialSubjectData[displayInstructionKey].toString();
          }
        } else {
          if (credentialSubjectData[displayInstructionKey] != null) {
            title = null;
            data = credentialSubjectData[displayInstructionKey] is Map ||
                    credentialSubjectData[displayInstructionKey] is List
                ? jsonEncode(credentialSubjectData[displayInstructionKey])
                : credentialSubjectData[displayInstructionKey].toString();
          } else {
            return const SizedBox.shrink();
          }
        }
// check if that's a picture which is displayed on the card.
        final valueType = displayInstructionValue['value_type'];
        if (Parameters.pictureOnCardValueTypeList.contains(valueType) &&
            Parameters.pictureOnCardKeyList.contains(displayInstructionKey)) {
          return const SizedBox.shrink();
        }
        if (data == null) return const SizedBox.shrink();
        late Widget widget;
        final nestedFieldsFromDisplayInstruction =
            Map<String, dynamic>.from(displayInstructionValue);
        nestedFieldsFromDisplayInstruction.remove('display');
        nestedFieldsFromDisplayInstruction.remove('value_type');
        nestedFieldsFromDisplayInstruction.remove('mandatory');
        if (nestedFieldsFromDisplayInstruction.isNotEmpty) {
          try {
            final json = jsonDecode(data);
            final List<Widget> column = [];
            if (json is Map<String, dynamic>) {
              column.addAll(
                displayBlock(
                  json,
                  nestedFieldsFromDisplayInstruction,
                  languageCode,
                ),
              );
            }
            if (json is List<dynamic>) {
              for (final listElement in json) {
                if (listElement is Map<String, dynamic>) {
                  column.add(
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: displayBlock(
                          listElement,
                          nestedFieldsFromDisplayInstruction,
                          languageCode,
                        ),
                      ),
                    ),
                  );
                }
              }
            }

            /// for each element in Map toto, call displayWidget

            widget = IndentedCredentialFields(
              title: title,
              children: column,
            );
          } catch (e) {
            return const SizedBox.shrink();
          }
        } else {
          widget = DisplayCredentialField(
            title: title,
            data: data,
            type: displayInstructionValue['value_type'].toString(),
            showVertically: showVertically,
          );
        }

        return widget;
      }).toList(),
    );
    return column;
  }

  List<Widget> displayBlock(
    Map<String, dynamic> json,
    Map<String, dynamic> nestedFieldsFromDisplayInstruction,
    String languageCode,
  ) {
    final List<Widget> column = [];
    late String? title;
    for (final element in nestedFieldsFromDisplayInstruction.entries) {
      final elementValue = element.value;
      if (elementValue is Map<String, dynamic>) {
        if (elementValue.containsKey('display')) {
          final display = getDisplay(elementValue, languageCode);

          title = display['name'].toString();
        } else {
          title = null;
        }

        if (elementValue.isEmpty) {
          column.add(
            DisplayCredentialField(
              title: title,
              data: json[element.key],
              showVertically: showVertically,
            ),
          );
        } else {
          column.add(
            displayWidget(
              {element.key: elementValue},
              languageCode,
              json,
            ),
          );
        }
      }
    }
    return column;
  }
}

class DisplayCredentialField extends StatelessWidget {
  const DisplayCredentialField({
    super.key,
    this.title,
    required this.data,
    this.type = 'string',
    required this.showVertically,
  });
  final String? title;
  final dynamic data;
  final String type;
  final bool showVertically;

  @override
  Widget build(BuildContext context) {
    Widget? widget;
    try {
      final json = jsonDecode(data.toString());
      if (json is Map<String, dynamic>) {
        widget = IndentedCredentialFields(
          title: title,
          children: DisplayCredentialFieldMap(
            showVertically: showVertically,
            data: json,
            type: type,
          ),
        );
      }

      if (json is List<dynamic>) {
        widget = IndentedCredentialFields(
          title: title,
          children: DisplayCredentialFieldList(
            showVertically: showVertically,
            data: json,
            type: type,
          ),
        );
      }
    } catch (e) {
      /// Empty catch because data is not a valid json and
      /// the return of the function will take care of
      /// this usecase (widget is null)
    }

    return widget ??
        CredentialField(
          padding: const EdgeInsets.only(top: 10),
          title: title,
          value: data.toString(),
          titleColor: Theme.of(context).colorScheme.onSurface,
          valueColor: Theme.of(context).colorScheme.onSurface,
          showVertically: showVertically,
          type: type,
        );
  }

  List<Widget> DisplayCredentialFieldMap({
    required bool showVertically,
    required Map<String, dynamic> data,
    required String type,
  }) {
    final List<Widget> column = [];

    /// for each element in Map data, call DisplayCredentialField
    for (final element in data.entries) {
      column.add(
        DisplayCredentialField(
          title: element.key,
          data: element.value is String
              ? element.value
              : jsonEncode(element.value),
          type: type,
          showVertically: showVertically,
        ),
      );
    }

    return column;
  }

  List<Widget> DisplayCredentialFieldList({
    required bool showVertically,
    required List<dynamic> data,
    required String type,
  }) {
    final List<Widget> column = [];

    /// for each element in Map data, call DisplayCredentialField
    for (final element in data) {
      column.add(
        DisplayCredentialField(
          title: null,
          data: element is String ? element : jsonEncode(element),
          type: type,
          showVertically: showVertically,
        ),
      );
    }

    return column;
  }
}

class IndentedCredentialFields extends StatelessWidget {
  const IndentedCredentialFields({
    super.key,
    required this.children,
    this.title,
  });

  final List<Widget> children;
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          )
        else
          const SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}
