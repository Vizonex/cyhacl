from cpython.buffer cimport PyBuffer_Release, PyObject_GetBuffer, PyBUF_SIMPLE
from cpython.bytes cimport PyBytes_FromStringAndSize
from cpython.unicode cimport PyUnicode_FromStringAndSize
from libc.stdint cimport UINT32_MAX, uint8_t, uint32_t
from libc.string cimport memset
cimport cython
from cpython.exc cimport PyErr_SetObject
from .compat cimport GIL_MIN_SIZE, IS_64BIT, cyhacl_strhex, get_buffer_view

from .hacl.Ed25519 cimport *

cdef int get_key_view(object key, Py_buffer* view) except -1:
    if PyObject_GetBuffer(key, &view, PyBUF_SIMPLE) < 0:
        return -1

    if view.len != 32:
        PyBuffer_Release(view)
        PyErr_SetObject(ValueError, f"key length should be exactly 32 bits, not {view.len}")
        return -1
    return 0

cdef int get_expanded_view(object key, Py_buffer* view) except -1:
    if PyObject_GetBuffer(key, &view, PyBUF_SIMPLE) < 0:
        return -1

    if view.len != 96:
        PyBuffer_Release(view)
        PyErr_SetObject(ValueError, f"expanded key length should be exactly 96 bits, not {view.len}")
        return -1
    return 0

cdef int get_signature_view(object key, Py_buffer* view) except -1:
    if PyObject_GetBuffer(key, &view, PyBUF_SIMPLE) < 0:
        return -1

    if view.len != 64:
        PyBuffer_Release(view)
        PyErr_SetObject(ValueError, f"signature length should be exactly 64 bits, not {view.len}")
        return -1
    return 0

cpdef bytes secret_to_public(object private_key):
    """Computes the public key from the private key"""
    cdef Py_buffer view
    cdef uint8_t public_key[32]
    
    if get_key_view(private_key, &view) < 0:
        raise
    with nogil:
        Hacl_Ed25519_secret_to_public(public_key, <uint8_t*>view.buf)
    PyBuffer_Release(&view)
    return PyBytes_FromStringAndSize(<char*>public_key, 32)


cdef class Ed25519_Enc:
    """An Encryption class for encrypting messages"""
    cdef cython.pymutex mutex
    cdef uint8_t expanded_secret[96]
    cdef uint8_t _private_key[32]

    def __init__(self, object private_key) -> None:
        cdef Py_buffer view
        if get_key_view(private_key, &view) < 0:
            raise
        self._private_key = <uint8_t*>view.buf
        PyBuffer_Release(&view)
        with nogil:
            Hacl_Ed25519_expand_keys(self.expanded_secret, <uint8_t*>view.buf)

    @property
    def public_key(self) -> bytes:
        """Public Key used for this encryption."""
        cdef uint8_t public_key[32]
        with nogil:
            Hacl_Ed25519_secret_to_public(public_key, self._private_key)
        return PyBytes_FromStringAndSize(<char*>public_key, 32)

    cpdef void reset(self):
        """resets the current signature"""
        with self.mutex:
            with nogil:
                Hacl_Ed25519_expand_keys(self.expanded_secret, self._private_key)

    @property
    def private_key(self) -> bytes:
        """Private key used for this encryption."""
        return PyBytes_FromStringAndSize(<char*>self._private_key, 32)

    
    cpdef object sign(self, object msg):
        """Create an Ed25519 signature with the (precomputed) expanded keys
        returrns the signature used."""
        cdef Py_buffer view
        cdef uint8_t signature[64]

        if PyObject_GetBuffer(msg, &view, PyBUF_SIMPLE) < 0:
            raise
        try:
            with self.mutex:
                with nogil:
                    Hacl_Ed25519_sign_expanded(signature, self.expanded_secret, <uint32_t>view.len, <uint8_t*>view.buf)
        finally:
            PyBuffer_Release(&view)
        return PyBytes_FromStringAndSize(signature, 64)

        
    
cdef class Ed25519_Dec:
    """A Decryption class for verifying the encryption."""
    cdef uint8_t _key[32]
    
    def __init__(self, object public_key) -> None:
        cdef Py_buffer view
        if get_key_view(public_key, &view) < 0:
            raise
        
        self._key = <uint8_t*>view.buf
        PyBuffer_Release(&view)
    
    def verify(self, object message, object signature):
        
        Hacl_Ed25519_verify(self._key, )




cpdef bytes sign(object private_key, object msg):
    """Creates an Ed25519 signature."""
    cdef Py_buffer key, msg_view
    cdef uint8_t signature[64]

    if get_key_view(private_key, &key) < 0:
        raise
    
    if PyObject_GetBuffer(msg, &msg_view, PyBUF_SIMPLE) < 0:
        PyBuffer_Release(&key)
        raise

    with nogil:
        Hacl_Ed25519_sign(signature, <uint8_t*>key.buf, <uint32_t>msg_view.len, msg_view.buf)
    
    return PyBytes_FromStringAndSize(<char*>signature, 64)







