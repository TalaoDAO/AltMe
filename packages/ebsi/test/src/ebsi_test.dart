// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ebsi/ebsi.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('Ebsi', () {
    test('can be instantiated', () {
      final client = MockDio();
      expect(Ebsi(client: client), isNotNull);
    });
    test(
        'When getCredentialRequest receive good url it returns credential_type',
        () {
      const openidRequest =
          'openid://initiate_issuance?issuer=https%3A%2F%2Fapi.conformance.intebsi.xyz%2Fconformance%2Fv2&credential_type=https%3A%2F%2Fapi.conformance.intebsi.xyz%2Ftrusted-schemas-registry%2Fv2%2Fschemas%2FzCfNxx5dMBdf4yVcsWzj1anWRuXcxrXj1aogyfN1xSu8t&conformance=ec4d929a-5439-46fb-b7d3-4a1a80d0c199';
      const credentialTypeRequest =
          'https://api.conformance.intebsi.xyz/trusted-schemas-registry/v2/schemas/zCfNxx5dMBdf4yVcsWzj1anWRuXcxrXj1aogyfN1xSu8t';
      final client = MockDio();
      expect(
        Ebsi(client: client).getCredentialRequest(openidRequest),
        credentialTypeRequest,
      );
    });
    test('When getCredentialRequest receive bad url it returns ""', () {
      const openidRequest = 'this is a bad request :-)';
      final client = MockDio();
      expect(Ebsi(client: client).getCredentialRequest(openidRequest), '');
    });

    test('Some fun', () {
from flask import Flask, request, jsonify
import socket
import requests
import json
from urllib.parse import parse_qs, urlparse
from jwcrypto import jwk, jwt
from datetime import datetime
import hashlib
import base58
​
# jwcrypto EC: crv(str) (one of P-256, P-384, P-521, secp256k1)
​
app = Flask(__name__)
​
# IP tunnel for external server
ngrok = "https://1253-77-140-52-235.ngrok.io"
​
# EBSI
conformance = "36c751ad-7c32-4baa-ab5c-2a303aad548f"
​
# wallet key
KEY_DICT = {"crv":"secp256k1",
"d":"lbuGEjEsYQ205boyekj8qdCwB2Uv7L2FwHUNleJj_Z0",
"kty":"EC",
"x":"AARiMrLNsRka9wMEoSgMnM7BwPug4x9IqLDwHVU-1A4",
"y":"vKMstC3TEN3rVW32COQX002btnU70v6P73PMGcUoZQs",
 "alg" : 'ES256'}
​
# pour calculer did:ebsi
def thumbprint_ebsi(jwk) :
    """
    https://www.rfc-editor.org/rfc/rfc7638.html
    """
    if isinstance(jwk, str) :
        jwk = json.loads(jwk)
    JWK = json.dumps({
                    "crv":"P-256",
                    "kty":"EC",
                    "x":jwk["x"],
                    "y":jwk["y"]
                    }).replace(" ","")
    m = hashlib.sha256()
    m.update(JWK.encode())
    return m.hexdigest()
​
​
# pour calculer did:ebsi (Natural Person)
def did_ebsi(jwk) :
    """
    https://ec.europa.eu/digital-building-blocks/wikis/display/EBSIDOC/EBSI+DID+Method
    """
    if isinstance(jwk, str) :
        jwk = json.loads(jwk)
    return  'did:ebsi:z' + base58.b58encode(b'\x02' + bytes.fromhex(thumbprint_ebsi(jwk))).decode()
​
​
# calcul did:ebsi
did = did_ebsi(KEY_DICT)
#did = "did:ebsi:zeGEwSVjZDxc5aDmBsRSvYtwvdSSmQw2k9A39vm4PwyAt"
​
​
# qrcode du test copliance 
qrcode = "openid://initiate_issuance?issuer=https%3A%2F%2Fapi.conformance.intebsi.xyz%2Fconformance%2Fv2&credential_type=https%3A%2F%2Fapi.conformance.intebsi.xyz%2Ftrusted-schemas-registry%2Fv2%2Fschemas%2Fz6EoWU6KYRjy7mR9VuKecgsNAuBkYGF3H94PdqgcEdQtp&conformance=36c751ad-7c32-4baa-ab5c-2a303aad548f"
parse_result = urlparse(qrcode)
result = parse_qs(parse_result.query)
issuer = result['issuer'][0]
credential_type = result["credential_type"][0]
​
    
def authorization_request(ngrok, conformance, credential_type ) :
    headers = {
        'Conformance' : conformance,
        'Content-Type': 'application/json'
        }
    url = "https://api.conformance.intebsi.xyz/conformance/v2/issuer-mock/authorize"
    my_request = {
        "scope" : "openid",
        "client_id" : ngrok + "/callback",
        "response_type" : "code",
        "authorization_details" : json.dumps([{"type":"openid_credential",
                        "credential_type": credential_type,
                        "format":"jwt_vc"}]),
        "redirect_uri" :  ngrok + "/callback",
        "state" : "1234"
        }
    resp = requests.get(url, headers=headers, params = my_request)
    print("status code = ", resp.status_code)
    if resp.status_code == 200 :
        return resp.json()
    else :
        return None
​
​
def token_request(code, ngrok ) :
    headers = {
        'Conformance' : conformance,
        'Content-Type': 'application/x-www-form-urlencoded'
        }
    url = "https://api.conformance.intebsi.xyz/conformance/v2/issuer-mock/token"
    data = { "code" : code,
            "grant_type" : "authorization_code",
            "redirect_uri" :  ngrok + "/callback"
        }
    resp = requests.post(url, headers=headers, data = data)
    if resp.status_code == 200 :
        return resp.json()
    else :
        return None
​
​
def build_proof(nonce) :
    verifier_key = jwk.JWK(**KEY_DICT) 
    header = {
        "typ" :"JWT",
        "alg": "ES256K",
        "jwk" : {"crv":"secp256k1",
                "kty":"EC",
                "x":"AARiMrLNsRka9wMEoSgMnM7BwPug4x9IqLDwHVU-1A4",
                "y":"vKMstC3TEN3rVW32COQX002btnU70v6P73PMGcUoZQs"
                }
    }
    payload = {
        "iss" : did,
        "nonce" : nonce,
        "iat": datetime.timestamp(datetime.now()),
        "aud" : issuer
    }  
    token = jwt.JWT(header=header,claims=payload, algs=["ES256K"])
    token.make_signed_token(verifier_key)
    return token.serialize()
​
​
def credential_request(access_token, proof ) :
    headers = {
        'Conformance' : conformance,
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + access_token 
        }
    url = "https://api.conformance.intebsi.xyz/conformance/v2/issuer-mock/credential"
​
    data = { "type" : credential_type,
            "format" : "jwt_vc",
            "proof" : {
                "proof_type": "jwt",
                "jwt": proof
            }
    }
    resp = requests.post(url, headers=headers, data = json.dumps(data))
    if resp.status_code == 200 :
        return resp.json()
    else :
        return None
​
​
# authorization request
@app.route('/start' , methods=['GET', 'POST'])
def start() :
    authorization_request(ngrok, conformance, credential_type)
    return jsonify("Authorization request sent")
​
​
@app.route('/callback' , methods=['GET', 'POST']) 
def callback() :
    print("callback received")  
    # code received
    code = request.args["code"]
​
    # access token request
    result = token_request(code, ngrok )
    access_token = result["access_token"]
    c_nonce = result["c_nonce"]
​
    # build proof of kety ownership
    proof = build_proof(c_nonce)
​
    # credetial request
    result = credential_request(access_token, proof )
    print("credential = ", result)
    return jsonify('ok')
​
​
# local http server init
def extract_ip():
    st = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:       
        st.connect(('10.255.255.255', 1))
        IP = st.getsockname()[0]
    except Exception:
        IP = '127.0.0.1'
    finally:
        st.close()
    return IP
​
​
# MAIN entry point. Flask http server
if __name__ == '__main__':
    # to get the local server IP 
    IP = extract_ip()
    # server start
    app.run(host = IP, port= 4000, debug=True)    });

    test('When getCredentialType receive url it returns json response', () {
      const credentialTypeRequest =
          'https://api.conformance.intebsi.xyz/trusted-schemas-registry/v2/schemas/zCfNxx5dMBdf4yVcsWzj1anWRuXcxrXj1aogyfN1xSu8t';
      const jsonResponse =
          r'{"$schema":"http://json-schema.org/draft-07/schema#","title":"EBSI Natural Person Verifiable ID","description":"Schema of an EBSI Verifiable ID for a natural person","type":"object","allOf":[{"$ref":"https://api.conformance.intebsi.xyz/trusted-schemas-registry/v1/schemas/0x28d76954924d1c4747a4f1f9e3e9edc9ca965efbf8ff20e4339c2bf2323a5773"},{"properties":{"credentialSubject":{"description":"Defines additional information about the subject that is described by the Verifiable ID","type":"object","properties":{"id":{"description":"Defines the DID of the subject that is described by the Verifiable Attestation","type":"string","format":"uri"},"familyName":{"description":"Defines current family name(s) of the credential subject","type":"string"},"firstName":{"description":"Defines current first name(s) of the credential subject","type":"string"},"dateOfBirth":{"description":"Defines date of birth of the credential subject","type":"string","format":"date"},"personalIdentifier":{"description":"Defines the unique national identifier of the credential subject (constructed by the sending Member State in accordance with the technical specifications for the purposes of cross-border identification and which is as persistent as possible in time)","type":"string"},"nameAndFamilyNameAtBirth":{"description":"Defines the first and the family name(s) of the credential subject at the time of their birth","type":"string"},"placeOfBirth":{"description":"Defines the place where the credential subjectis born","type":"string"},"currentAddress":{"description":"Defines the current address of the credential subject","type":"string"},"gender":{"description":"Defines the gender of the credential subject","type":"string"}},"required":["id","familyName","firstName","dateOfBirth","personalIdentifier"]}}}]}';
      final client = MockDio();
      when(() => client.get(any())).thenAnswer((_) async {
        return jsonDecode(jsonResponse) as Future<Response>;
      });
      expect(
        Ebsi(client: client).getCredentialType(credentialTypeRequest),
        jsonResponse,
      );
    });
    test('When getCredentialType receive url, a request is done with Dio',
        () async {
      const credentialTypeRequest =
          'https://api.conformance.intebsi.xyz/trusted-schemas-registry/v2/schemas/zCfNxx5dMBdf4yVcsWzj1anWRuXcxrXj1aogyfN1xSu8t';
      const jsonResponse =
          r'{"$schema":"http://json-schema.org/draft-07/schema#","title":"EBSI Natural Person Verifiable ID","description":"Schema of an EBSI Verifiable ID for a natural person","type":"object","allOf":[{"$ref":"https://api.conformance.intebsi.xyz/trusted-schemas-registry/v1/schemas/0x28d76954924d1c4747a4f1f9e3e9edc9ca965efbf8ff20e4339c2bf2323a5773"},{"properties":{"credentialSubject":{"description":"Defines additional information about the subject that is described by the Verifiable ID","type":"object","properties":{"id":{"description":"Defines the DID of the subject that is described by the Verifiable Attestation","type":"string","format":"uri"},"familyName":{"description":"Defines current family name(s) of the credential subject","type":"string"},"firstName":{"description":"Defines current first name(s) of the credential subject","type":"string"},"dateOfBirth":{"description":"Defines date of birth of the credential subject","type":"string","format":"date"},"personalIdentifier":{"description":"Defines the unique national identifier of the credential subject (constructed by the sending Member State in accordance with the technical specifications for the purposes of cross-border identification and which is as persistent as possible in time)","type":"string"},"nameAndFamilyNameAtBirth":{"description":"Defines the first and the family name(s) of the credential subject at the time of their birth","type":"string"},"placeOfBirth":{"description":"Defines the place where the credential subjectis born","type":"string"},"currentAddress":{"description":"Defines the current address of the credential subject","type":"string"},"gender":{"description":"Defines the gender of the credential subject","type":"string"}},"required":["id","familyName","firstName","dateOfBirth","personalIdentifier"]}}}]}';
      final client = MockDio();
      when(() => client.get(any())).thenAnswer((_) async {
        return jsonDecode(jsonResponse) as Future<Response>;
      });
      await Ebsi(client: client).getCredentialType(credentialTypeRequest);
      verify(() => client.get<String>(credentialTypeRequest)).called(1);
    });
  });
}
