cimport cython
from ..hacl.sha2 cimport *

cdef class sha224:
    cdef:
        cython.pymutex mutex
        Hacl_Hash_SHA2_state_t_224* state

    cpdef sha224 copy(self)
    cpdef str hexdigest(self)
    cpdef bytes digest(self)
    cdef void c_update(self, uint8_t* data, Py_ssize_t size)
    cpdef object update(self, object obj)


cdef class sha256:
    cdef:
        cython.pymutex mutex
        Hacl_Hash_SHA2_state_t_256* state

    cpdef sha256 copy(self)
    cpdef str hexdigest(self)
    cpdef bytes digest(self)
    cdef void c_update(self, uint8_t* data, Py_ssize_t size)
    cpdef object update(self, object obj)


cdef class sha384:
    cdef:
        cython.pymutex mutex
        Hacl_Hash_SHA2_state_t_384* state

    cpdef sha384 copy(self)
    cpdef str hexdigest(self)
    cpdef bytes digest(self)
    cdef void c_update(self, uint8_t* data, Py_ssize_t size)
    cpdef object update(self, object obj)

cdef class sha512:
    cdef:
        cython.pymutex mutex
        Hacl_Hash_SHA2_state_t_512* state

    cpdef sha512 copy(self)
    cpdef str hexdigest(self)
    cpdef bytes digest(self)
    cdef void c_update(self, uint8_t* data, Py_ssize_t size)
    cpdef object update(self, object obj)
