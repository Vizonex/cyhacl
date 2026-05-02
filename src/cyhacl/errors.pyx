# ideas from pyhacl

cdef class HACLError(Exception):
    pass

cdef class DecryptionError(HACLError):
    pass

cdef class CryptoKeyError(HACLError):
    pass

