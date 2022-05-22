class NftModel {
  NftModel({
    this.assetUrl =
        'https://ipfs.io/ipfs/QmaukD3nc8zhAgQvruZRrHyeXpXnWgu3nnEatWUFt94ovi',
    this.description = 'Abstract Smoke Red something else ',
    this.assetValue = '1.25 ETH',
  });

  final String assetUrl;
  final String description;
  final String assetValue;

  static List<NftModel> fakeList() => List.generate(14, (index) => NftModel());
}
