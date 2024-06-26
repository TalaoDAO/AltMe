const openIdCredentialIssuerConfigurationTest10 = {
  'credential_issuer': 'https://talao.co/issuer/grlvzckofy',
  'credential_endpoint': 'https://talao.co/issuer/grlvzckofy/credential',
  'deferred_credential_endpoint': 'https://talao.co/issuer/grlvzckofy/deferred',
  'authorization_servers': [
    'https://talao.co/issuer/grlvzckofy',
    'https://fake.com/as',
  ],
  'credential_configurations_supported': {
    'EudiPid': {
      'format': 'vc+sd-jwt',
      'scope': 'EudiPid_scope',
      'order': [
        'given_name',
        'family_name',
        'birth_date',
        'birth_place',
        'nationalities',
        'address',
        'age_equal_or_over',
        'age_birth_year',
        'issuing_country',
        'issuing_authority',
        'dateIssued',
      ],
      'claims': {
        'given_name': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'First Name', 'locale': 'en-US'},
            {'name': 'Pr\u00e9nom', 'locale': 'fr-FR'},
          ],
        },
        'family_name': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Family Name', 'locale': 'en-US'},
            {'name': 'Nom', 'locale': 'fr-FR'},
          ],
        },
        'birth_date': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Birth date', 'locale': 'en-US'},
            {'name': 'Date de naissance', 'locale': 'fr-FR'},
          ],
        },
        'birth_place': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Birth place', 'locale': 'en-US'},
            {'name': 'Lieu de naissance', 'locale': 'fr-FR'},
          ],
        },
        'nationalities': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Nationalities', 'locale': 'en-US'},
            {'name': 'Nationalit\u00e9s', 'locale': 'fr-FR'},
          ],
        },
        'age_equal_or_over': {
          'mandatory': true,
          'value_type': 'bool',
          'display': [
            {'name': 'Age', 'locale': 'en-US'},
            {'name': 'Age', 'locale': 'fr-FR'},
          ],
          '12': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Over 12', 'locale': 'en-US'},
              {'name': 'Plus de 12 ans', 'locale': 'fr-FR'},
            ],
          },
          '14': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Over 14', 'locale': 'en-US'},
              {'name': 'Plus de 14 ans', 'locale': 'fr-FR'},
            ],
          },
          '16': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Over 16', 'locale': 'en-US'},
              {'name': 'Plus de 16 ans', 'locale': 'fr-FR'},
            ],
          },
          '18': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Over 18', 'locale': 'en-US'},
              {'name': 'Plus de 18 ans', 'locale': 'fr-FR'},
            ],
          },
          '21': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Over 21', 'locale': 'en-US'},
              {'name': 'Plus de 21 ans', 'locale': 'fr-FR'},
            ],
          },
          '65': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Senior', 'locale': 'en-US'},
              {'name': 'Senior', 'locale': 'fr-FR'},
            ],
          },
        },
        'address': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Address', 'locale': 'en-US'},
            {'name': 'Adresse', 'locale': 'fr-FR'},
          ],
          'street_address': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Street address', 'locale': 'en-US'},
              {'name': 'Rue', 'locale': 'fr-FR'},
            ],
          },
          'locality': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Locality', 'locale': 'en-US'},
              {'name': 'Ville', 'locale': 'fr-FR'},
            ],
          },
          'region': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Region', 'locale': 'en-US'},
              {'name': 'R\u00e9gion', 'locale': 'fr-FR'},
            ],
          },
          'country': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Country', 'locale': 'en-US'},
              {'name': 'Pays', 'locale': 'fr-FR'},
            ],
          },
        },
        'picture': {
          'mandatory': true,
          'value_type': 'image/jpeg',
          'display': [
            {'name': 'Picture', 'locale': 'en-US'},
            {'name': 'Portrait', 'locale': 'fr-FR'},
          ],
        },
        'age_birth_year': {
          'mandatory': true,
          'value_type': 'integer',
          'display': [
            {'name': 'Age birth year', 'locale': 'en-US'},
            {'name': 'Ann\u00e9e de naissance', 'locale': 'fr-FR'},
          ],
        },
        'dateIssued': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Issuance date', 'locale': 'en-US'},
            {'name': 'D\u00e9livr\u00e9 le', 'locale': 'fr-FR'},
          ],
        },
        'expiry_date': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Expiry date', 'locale': 'en-US'},
            {'name': "Date d'expiration", 'locale': 'fr-FR'},
          ],
        },
        'issuing_country': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Issuing country', 'locale': 'en-US'},
            {'name': "Pays d'emission", 'locale': 'fr-FR'},
          ],
        },
        'issuing_authority': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Issuing autority', 'locale': 'en-US'},
            {'name': "Authorit\u00e9 d'emission", 'locale': 'fr-FR'},
          ],
        },
      },
      'cryptographic_binding_methods_supported': ['DID', 'jwk'],
      'credential_signing_alg_values_supported': [
        'ES256K',
        'ES256',
        'ES384',
        'RS256',
      ],
      'vct': 'EUDI_PID_rule_book_1_0_0',
      'display': [
        {
          'name': 'EUDI PID',
          'locale': 'en-US',
          'background_color': '#14107c',
          'text_color': '#FFFFFF',
        }
      ],
    },
    'Pid': {
      'format': 'vc+sd-jwt',
      'scope': 'Pid_scope',
      'order': [
        'given_name',
        'family_name',
        'birthdate',
        'address',
        'gender',
        'place_of_birth',
        'nationalities',
        'age_equal_or_over',
        'issuing_country',
        'issuing_authority',
      ],
      'claims': {
        'given_name': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'First Name', 'locale': 'en-US'},
            {'name': 'Pr\u00e9nom', 'locale': 'fr-FR'},
          ],
        },
        'family_name': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Family Name', 'locale': 'en-US'},
            {'name': 'Nom', 'locale': 'fr-FR'},
          ],
        },
        'birthdate': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Birth date', 'locale': 'en-US'},
            {'name': 'Date de naissance', 'locale': 'fr-FR'},
          ],
        },
        'place_of_birth': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Birth place', 'locale': 'en-US'},
            {'name': 'Lieu de naissance', 'locale': 'fr-FR'},
          ],
          'locality': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Locality', 'locale': 'en-US'},
              {'name': 'Ville', 'locale': 'fr-FR'},
            ],
          },
          'region': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Region', 'locale': 'en-US'},
              {'name': 'R\u00e9gion', 'locale': 'fr-FR'},
            ],
          },
          'country': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Country', 'locale': 'en-US'},
              {'name': 'Pays', 'locale': 'fr-FR'},
            ],
          },
        },
        'nationalities': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Nationalities', 'locale': 'en-US'},
            {'name': 'Nationalit\u00e9s', 'locale': 'fr-FR'},
          ],
        },
        'gender': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Gender', 'locale': 'en-US'},
            {'name': 'Sexe', 'locale': 'fr-FR'},
          ],
        },
        'address': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Address', 'locale': 'en-US'},
            {'name': 'Adresse', 'locale': 'fr-FR'},
          ],
          'formatted': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Formatted', 'locale': 'en-US'},
              {'name': 'Complete', 'locale': 'fr-FR'},
            ],
          },
          'street_address': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Street address', 'locale': 'en-US'},
              {'name': 'Rue', 'locale': 'fr-FR'},
            ],
          },
          'locality': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Locality', 'locale': 'en-US'},
              {'name': 'Ville', 'locale': 'fr-FR'},
            ],
          },
          'region': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Region', 'locale': 'en-US'},
              {'name': 'R\u00e9gion', 'locale': 'fr-FR'},
            ],
          },
          'country': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Country', 'locale': 'en-US'},
              {'name': 'Pays', 'locale': 'fr-FR'},
            ],
          },
        },
        'age_equal_or_over': {
          'mandatory': true,
          'value_type': 'bool',
          'display': [
            {'name': 'Age', 'locale': 'en-US'},
            {'name': 'Age', 'locale': 'fr-FR'},
          ],
          '12': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Over 12', 'locale': 'en-US'},
              {'name': 'Plus de 12 ans', 'locale': 'fr-FR'},
            ],
          },
          '14': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Over 14', 'locale': 'en-US'},
              {'name': 'Plus de 14 ans', 'locale': 'fr-FR'},
            ],
          },
          '16': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Over 16', 'locale': 'en-US'},
              {'name': 'Plus de 16 ans', 'locale': 'fr-FR'},
            ],
          },
          '18': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Over 18', 'locale': 'en-US'},
              {'name': 'Plus de 18 ans', 'locale': 'fr-FR'},
            ],
          },
          '21': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Over 21', 'locale': 'en-US'},
              {'name': 'Plus de 21 ans', 'locale': 'fr-FR'},
            ],
          },
          '65': {
            'mandatory': true,
            'value_type': 'string',
            'display': [
              {'name': 'Senior', 'locale': 'en-US'},
              {'name': 'Senior', 'locale': 'fr-FR'},
            ],
          },
        },
        'picture': {
          'mandatory': true,
          'value_type': 'image/jpeg',
          'display': [
            {'name': 'Picture', 'locale': 'en-US'},
            {'name': 'Portrait', 'locale': 'fr-FR'},
          ],
        },
        'dateIssued': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Issuance date', 'locale': 'en-US'},
            {'name': 'D\u00e9livr\u00e9 le', 'locale': 'fr-FR'},
          ],
        },
        'expiry_date': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Expiry date', 'locale': 'en-US'},
            {'name': "Date d'expiration", 'locale': 'fr-FR'},
          ],
        },
        'issuing_country': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Issuing country', 'locale': 'en-US'},
            {'name': "Pays d'emission", 'locale': 'fr-FR'},
          ],
        },
        'issuing_authority': {
          'mandatory': true,
          'value_type': 'string',
          'display': [
            {'name': 'Issuing autority', 'locale': 'en-US'},
            {'name': "Authorit\u00e9 d'emission", 'locale': 'fr-FR'},
          ],
        },
      },
      'cryptographic_binding_methods_supported': ['DID', 'jwk'],
      'credential_signing_alg_values_supported': [
        'ES256K',
        'ES256',
        'ES384',
        'RS256',
      ],
      'vct': 'urn:eu.europa.ec.eudi:pid:1',
      'display': [
        {
          'name': 'PID',
          'locale': 'en-US',
          'background_color': '#14107c',
          'text_color': '#FFFFFF',
        },
        {
          'name': 'PID',
          'locale': 'fr-FR',
          'background_color': '#14107c',
          'text_color': '#FFFFFF',
        }
      ],
    },
  },
};

const openIdConfigurationTest10 = {
  'authorization_endpoint': 'https://talao.co/issuer/grlvzckofy/authorize',
  'token_endpoint': 'https://talao.co/issuer/grlvzckofy/token',
  'jwks_uri': 'https://talao.co/issuer/grlvzckofy/jwks',
  'pushed_authorization_request_endpoint':
      'https://talao.co/issuer/grlvzckofy/authorize/par',
  'require_pushed_authorization_requests': true,
  'scopes_supported': ['openid'],
  'response_types_supported': ['vp_token', 'id_token'],
  'response_modes_supported': ['query'],
  'grant_types_supported': [
    'authorization_code',
    'urn:ietf:params:oauth:grant-type:pre-authorized_code',
  ],
  'subject_types_supported': ['public', 'pairwise'],
  'id_token_signing_alg_values_supported': [
    'ES256',
    'ES256K',
    'EdDSA',
    'RS256',
  ],
  'request_object_signing_alg_values_supported': [
    'ES256',
    'ES256K',
    'EdDSA',
    'RS256',
  ],
  'request_parameter_supported': true,
  'request_uri_parameter_supported': true,
  'token_endpoint_auth_methods_supported': [
    'client_secret_basic',
    'client_secret_post',
    'client_secret_jwt',
    'none',
  ],
  'request_authentication_methods_supported': {
    'authorization_endpoint': ['request_object'],
  },
  'subject_syntax_types_supported': [
    'urn:ietf:params:oauth:jwk-thumbprint',
    'did:key',
    'did:ebsi',
    'did:tz',
    'did:pkh',
    'did:hedera',
    'did:key',
    'did:ethr',
    'did:web',
    'did:jwk',
  ],
  'subject_syntax_types_discriminations': [
    'did:key:jwk_jcs-pub',
    'did:ebsi:v1',
  ],
  'subject_trust_frameworks_supported': ['ebsi'],
  'id_token_types_supported': ['subject_signed_id_token'],
};

const credentialOfferJsonAuthorizedTest10 = {
  'credential_issuer': 'https://talao.co/issuer/grlvzckofy',
  'credential_configuration_ids': ['Pid'],
  'grants': {
    'authorization_code': {
      'issuer_state': 'test10',
      'authorization_server': 'https://talao.co/issuer/grlvzckofy',
    },
  },
};

const credentialOfferJsonPreAuthorizedTest10 = {
  'credential_issuer': 'https://talao.co/issuer/grlvzckofy',
  'credential_configuration_ids': ['Pid'],
  'grants': {
    'urn:ietf:params:oauth:grant-type:pre-authorized_code': {
      'issuer_state': 'test10',
      'authorization_server': 'https://talao.co/issuer/grlvzckofy',
    },
  },
};
