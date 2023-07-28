const privateKey = {
  'crv': 'P-256K',
  'd': 'ccWWNSjGiv1iWlNh4kfhWvwG3yyQMe8o31Du0uKRzrs',
  'kty': 'EC',
  'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
  'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE'
};

const privateKey2 = {
  'crv': 'P-256',
  'd': 'ccWWNSjGiv1iWlNh4kfhWvwG3yyQMe8o31Du0uKRzrs',
  'kty': 'EC',
  'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
  'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE'
};

const publicJWK = {
  'crv': 'P-256K',
  'kty': 'EC',
  'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
  'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE'
};

const keyWithAlg = {
  'crv': 'P-256K',
  'd': 'ccWWNSjGiv1iWlNh4kfhWvwG3yyQMe8o31Du0uKRzrs',
  'kty': 'EC',
  'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
  'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE',
  'alg': 'HS256',
};

const didKey = 'did:ebsi:zo9FR1YfAKFP3Q6dvqhxcXxnfeDiJDP97kmnqhyAUSACj';

const kid =
    '''did:ebsi:zo9FR1YfAKFP3Q6dvqhxcXxnfeDiJDP97kmnqhyAUSACj#Cgcg1y9xj9uWFw56PMc29XBd9EReixzvnftBz8JwQFiB''';

const ES256Alg = 'ES256';

const ES256KAlg = 'ES256K';

const HS256Alg = 'HS256';

const thumbprint = [
  173,
  150,
  139,
  1,
  202,
  186,
  32,
  132,
  51,
  6,
  216,
  230,
  103,
  154,
  26,
  196,
  52,
  23,
  248,
  132,
  91,
  7,
  58,
  174,
  149,
  38,
  148,
  157,
  199,
  122,
  118,
  36,
];

const rfc7638Jwk = {
  'e': 'AQAB',
  'kty': 'RSA',
  'n':
      // ignore: lines_longer_than_80_chars
      '0vx7agoebGcQSuuPiLJXZptN9nndrQmbXEps2aiAFbWhM78LhWx4cbbfAAtVT86zwu1RK7aPFFxuhDR1L6tSoc_BJECPebWKRXjBZCiFV4n3oknjhMstn64tZ_2W-5JsGY4Hc5n9yBXArwl93lqt7_RN5w6Cf0h4QyQ5v-65YGjQR0_FDW2QvzqY368QQMicAtaSqzs8KJZgnYb9c7d0zgdAZHzu6qMQvRL5hajrn1n91CbOpbISD08qNLyrdkt-bFTWhAI4vMQFh6WeZu0fM4lFd2NcRwr3XPksINHaQ-G_xBniIqbw0Ls1jF44-csFCur-kEgU8awapJzKnqDKgw'
};
const expectedThumbprintForrfc7638Jwk = [
  55,
  54,
  203,
  177,
  120,
  124,
  184,
  48,
  156,
  119,
  238,
  140,
  55,
  5,
  197,
  225,
  111,
  251,
  158,
  133,
  151,
  21,
  144,
  31,
  30,
  76,
  89,
  177,
  17,
  130,
  245,
  123
];
