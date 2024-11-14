from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives import serialization
import base64

private_key = ec.generate_private_key(ec.SECP256R1())

public_key = private_key.public_key()

private_bytes = private_key.private_bytes(
    encoding=serialization.Encoding.DER,
    format=serialization.PrivateFormat.PKCS8,
    encryption_algorithm=serialization.NoEncryption()
)

public_bytes = public_key.public_bytes(
    encoding=serialization.Encoding.DER,
    format=serialization.PublicFormat.SubjectPublicKeyInfo
)

private_key_b64 = base64.b64encode(private_bytes).decode('utf-8')
public_key_b64 = base64.b64encode(public_bytes).decode('utf-8')

print("Public Key:", public_key_b64)
print("Private Key:", private_key_b64)
