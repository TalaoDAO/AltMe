import 'package:credential_manifest/credential_manifest.dart';

PresentationDefinition applySubmissionRequirements(
    PresentationDefinition presentationDefinition) {
  if (presentationDefinition.submissionRequirements != null) {
    /// https://identity.foundation/presentation-exchange/#presentation-definition-extensions
    final inputDescriptors = List.of(presentationDefinition.inputDescriptors);

    final newInputDescriptor = <InputDescriptor>[];

    /// grouping
    while (inputDescriptors.isNotEmpty) {
      final currentFirst = inputDescriptors.removeAt(0);
      final group = currentFirst.group.toString();

      final descriptorsWithSameGroup = inputDescriptors
          .where((descriptor) => descriptor.group.toString() == group)
          .toList();

      if (descriptorsWithSameGroup.isNotEmpty) {
        final mergedDescriptor = InputDescriptor(
          id: '${currentFirst.id},${descriptorsWithSameGroup.map((e) => e.id).join(",")}', // ignore: lines_longer_than_80_chars
          name: [
            currentFirst.name,
            ...descriptorsWithSameGroup.map((e) => e.name),
          ].where((e) => e != null).join(','),
          constraints: Constraints([
            ...?currentFirst.constraints?.fields,
            for (final descriptor in descriptorsWithSameGroup)
              ...?descriptor.constraints?.fields,
          ]),
          group: currentFirst.group,
          purpose: [
            currentFirst.purpose,
            ...descriptorsWithSameGroup.map((e) => e.purpose),
          ].where((e) => e != null).join(','),
        );
        newInputDescriptor.add(mergedDescriptor);
        inputDescriptors.removeWhere(
          (descriptor) => descriptor.group.toString() == group,
        );
      } else {
        newInputDescriptor.add(currentFirst);
      }
    }

    presentationDefinition = PresentationDefinition.copyWithData(
      oldPresentationDefinition: presentationDefinition,
      inputDescriptors: newInputDescriptor,
    );
  }
  return presentationDefinition;
}
