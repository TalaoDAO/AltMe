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
    Map<String, dynamic> credentialSubjectReference,
    String languageCode,
    Map<String, dynamic> credentialSubjectData,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: credentialSubjectReference.entries
          .map((MapEntry<String, dynamic> map) {
        String? title;
        String? data;

        final key = map.key;
        final value = map.value;

        if (value is! Map<String, dynamic>) return const SizedBox.shrink();

        if (value.containsKey('display')) {
          final display = getDisplay(value, languageCode);
          if (display == null) return const SizedBox.shrink();

          if (credentialSubjectData.containsKey(key)) {
            title = display['name'].toString();
            data = credentialSubjectData[key] is Map
                ? jsonEncode(credentialSubjectData[key])
                : credentialSubjectData[key].toString();
          }
        } else {
          if (credentialSubjectData[key] != null) {
            title = null;
            data = credentialSubjectData[key] is Map
                ? jsonEncode(credentialSubjectData[key])
                : credentialSubjectData[key].toString();
          } else {
            return const SizedBox.shrink();
          }
        }

        if (data == null) return const SizedBox.shrink();
        late Widget widget;
        final nestedFields = Map<String, dynamic>.from(value);
        nestedFields.remove('display').remove('value_type');
        if (nestedFields.isNotEmpty) {
          try {
            final json = jsonDecode(data);
            if (json is! Map<String, dynamic>) {
              return const SizedBox.shrink();
            }
            final List<Widget> column = [];

            /// for each element in Map toto, call displayWidget

            for (final element in nestedFields.entries) {
              final elementValue = element.value;
              if (elementValue is Map<String, dynamic>) {
                if (elementValue.isEmpty) {
                  column.add(
                    DisplayCredentialField(
                      title: element.key,
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
            type: value['value_type'].toString(),
            showVertically: showVertically,
          );
        }

        return widget;
      }).toList(),
    );
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
