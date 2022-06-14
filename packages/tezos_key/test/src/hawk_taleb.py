# In py jwk -> tz1 or tz2 with  tezos basic lib
def jwk_to_tezos(jwk) :
    if isinstance(jwk, str) :
        jwk = json.loads(jwk)
    if jwk['crv'] == 'secp256k1' :
        prefix = b'spsk'
    elif jwk['crv'] == "Ed25519" :
        prefix = b'edsk'
    else :
        logging.error('curve not implemented')
        return None
    # Decode the key (d) from b64 to hex and complete to have a 32 bytes key with "=" at the end
    private_key = base64.urlsafe_b64decode(jwk["d"] + '=' * (4 - len(jwk["d"]) % 4)).hex()
    # add the prefix and encode in b58
    tez_pvk = base58_encode(bytes.fromhex(private_key), prefix = prefix)
    # Get public key and address from provate key
    sk = Key.from_encoded_key(tez_pvk.decode())
    pbk = sk.public_key()
    pkh = sk.public_key_hash()
    return tez_pvk, pbk, pkh


    # 