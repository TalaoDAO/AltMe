enum PolygonIdNetwork {
  PolygonMainnet,
  PolygonMumbai,
}

extension PolygonIdNetworkX on PolygonIdNetwork {
  String get name {
    switch (this) {
      case PolygonIdNetwork.PolygonMainnet:
        return 'Polygon Main';
      case PolygonIdNetwork.PolygonMumbai:
        return 'Polygon Mumbai';
    }
  }
}
