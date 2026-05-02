
# Cython HACL Error Type (Hacl_Streaming_Types)
cdef enum CYE:
    CYE_OK = 0 # Success
    CYE_INVALID_ALGORYTHM = 1 # Invalid Algorithm
    CYE_INVALID_LEN = 2  # Invalid Length
    CYE_MAX_LENGTH_EXCEEDED = 3 # Maximum Length Exceeded (Overflow)
    CYE_NO_MEMORY = 4 # OutOfMemory (In Python it's MemoryError) (OutOfMemory)


cdef class HACLError(Exception):
    pass

cdef class DecryptionError(HACLError):
    pass

cdef class CryptoKeyError(HACLError):
    pass
