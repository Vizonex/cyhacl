
def secret_to_public(private_key: object) -> bytes:
    """Computes the public key from the private key"""

class Ed25519:
    """An Encryption class for encrypting messages"""
    def __init__(self, private_key: object) -> None:
        ...
    
    @property
    def private_key(self) -> bytes:
        """Private key used for this encryption."""
        ...
    
    @property
    def signature(self) -> bytes:
        """a bytes version of the expanded secret."""
        ...
    
    def sign(self, msg: object) -> object:
        """Create an Ed25519 signature with the (precomputed) expanded keys."""
        ...
    

def sign(private_key: object, msg: object) -> bytes:
    """Creates an Ed25519 signature."""
    ...

def verify(public_key: object, message: object) -> bool:
    """Verifies the Ed25519 signature"""
    ...
