import 'package:altme/selective_disclosure/vc_selective_disclosure.dart';

class DcSelectiveDisclosure extends VcSelectiveDisclosure {
  DcSelectiveDisclosure(super.credentialModel);
  @override
  Map<String, dynamic> get claims {
    final credentialSupported = credentialModel.credentialSupported;
    final claimsList = credentialSupported?['claims'];
    if (claimsList == null || claimsList is! List<dynamic>) {
      return <String, dynamic>{};
    }
    Map<String, dynamic> recursiveClaims(
      List<dynamic> claimsList,
      int level,
      Map<String, dynamic> buildingClaims,
    ) {
      // Only consider claims with path.length == level
      final filtered = List<Map<String, dynamic>>.from(claimsList);
      filtered.removeWhere((claim) {
        final path = claim['path'];
        return path is! List<dynamic> || path.length != level;
      });
      if (filtered.isEmpty) {
        return buildingClaims;
      }
      for (final claim in filtered) {
        final path = claim['path'] as List<dynamic>;
        if (level == 1) {
          buildingClaims[path.last.toString()] = claim;
        } else {
          // Traverse the tree using the path list up to level-1
          Map<String, dynamic> parent = buildingClaims;
          for (int i = 0; i < level - 1; i++) {
            final key = path[i].toString();
            if (!parent.containsKey(key) ||
                parent[key] is! Map<String, dynamic>) {
              parent[key] = <String, dynamic>{};
            }
            parent = parent[key] as Map<String, dynamic>;
          }
          final String currentKey = path.last.toString();
          if (!parent.containsKey(currentKey)) {
            parent[currentKey] = claim;
          }
        }
      }
      return recursiveClaims(claimsList, level + 1, buildingClaims);
    }

    var claims = recursiveClaims(claimsList, 1, <String, dynamic>{});

    final order = credentialSupported?['order'];
    if (order != null && order is List<dynamic>) {
      final orderList = order.map((e) => e.toString()).toList();
      final orderedClaims = <String, dynamic>{};
      final remainingClaims = <String, dynamic>{};
      // Order elements based on the order list
      for (final key in orderList) {
        if (claims.containsKey(key)) {
          orderedClaims[key] = claims[key];
        }
      }
      // Add remaining elements to the end of the ordered map
      claims.forEach((key, value) {
        if (!orderedClaims.containsKey(key)) {
          remainingClaims[key] = value;
        }
      });
      orderedClaims.addAll(remainingClaims);
      claims = orderedClaims;
    }
    return claims;
  }
}
