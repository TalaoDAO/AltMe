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

  String get tester {
    switch (this) {
      case PolygonIdNetwork.PolygonMainnet:
        return 'polygon:main';
      case PolygonIdNetwork.PolygonMumbai:
        return 'polygon:mumbai';
    }
  }

  String get oppositeNetwork {
    switch (this) {
      case PolygonIdNetwork.PolygonMainnet:
        return 'mumbai(testnet)';
      case PolygonIdNetwork.PolygonMumbai:
        return 'mainnet';
    }
  }
}
