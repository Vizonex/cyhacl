"""
Exception classes for cyhacl.
"""

class HACLError(Exception):
    pass

class DecryptionError(HACLError):
    pass

class CryptoKeyError(HACLError):
    pass 


