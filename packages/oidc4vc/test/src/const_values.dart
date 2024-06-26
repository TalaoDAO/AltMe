const privateKey = {
  'crv': 'P-256K',
  'd': 'ccWWNSjGiv1iWlNh4kfhWvwG3yyQMe8o31Du0uKRzrs',
  'kty': 'EC',
  'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
  'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE',
};

const privateKey2 = {
  'crv': 'P-256',
  'd': 'ccWWNSjGiv1iWlNh4kfhWvwG3yyQMe8o31Du0uKRzrs',
  'kty': 'EC',
  'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
  'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE',
};

const publicJWK = {
  'crv': 'P-256K',
  'kty': 'EC',
  'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
  'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE',
};

const keyWithAlg = {
  'crv': 'P-256K',
  'd': 'ccWWNSjGiv1iWlNh4kfhWvwG3yyQMe8o31Du0uKRzrs',
  'kty': 'EC',
  'x': 'J4vQtLUyrVUiFIXRrtEq4xurmBZp2eq9wJmXkIA_stI',
  'y': 'EUU6vXoG3BGX2zzwjXrGDcr4EyDD0Vfk3_5fg5kSgKE',
  'alg': 'HS256',
};

const issuer = 'https://talao.co/issuer/zxhaokccsi';

const clientId =
    '''did:key:z2dmzD81cgPx8Vki7JbuuMmFYrWPgYoytykUZ3eyqht1j9Kbrbpg5is8LfTLuQ1RsW5r7s7ZjbDDFbDgy1tLrdc7Bj3itBGQkuGUQyfzKhFqbUNW2PqJPMSSzWoF2DGSvDSijCtJtYCSRsjSVLrwu5oHNbnPFvSEC4iRZPpU6B6nExRBTa''';

const kid = '';

const ES256Alg = 'ES256';

const ES256KAlg = 'ES256K';

const HS256Alg = 'HS256';

const thumbprint = 'rZaLAcq6IIQzBtjmZ5oaxDQX+IRbBzqulSaUncd6diQ';

const rfc7638Jwk = {
  'e': 'AQAB',
  'kty': 'RSA',
  'n':
      // ignore: lines_longer_than_80_chars
      '0vx7agoebGcQSuuPiLJXZptN9nndrQmbXEps2aiAFbWhM78LhWx4cbbfAAtVT86zwu1RK7aPFFxuhDR1L6tSoc_BJECPebWKRXjBZCiFV4n3oknjhMstn64tZ_2W-5JsGY4Hc5n9yBXArwl93lqt7_RN5w6Cf0h4QyQ5v-65YGjQR0_FDW2QvzqY368QQMicAtaSqzs8KJZgnYb9c7d0zgdAZHzu6qMQvRL5hajrn1n91CbOpbISD08qNLyrdkt-bFTWhAI4vMQFh6WeZu0fM4lFd2NcRwr3XPksINHaQ-G_xBniIqbw0Ls1jF44-csFCur-kEgU8awapJzKnqDKgw',
};
const expectedThumbprintForrfc7638Jwk =
    'NzbLsXh8uDCcd+6MNwXF4W/7noWXFZAfHkxZsRGC9Xs';
