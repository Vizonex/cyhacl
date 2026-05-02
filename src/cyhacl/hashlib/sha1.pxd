cimport cython
from ..hacl.sha1 cimport *


cdef class sha1:
    """uses the sha1 hashing algorythm."""
    cdef:
        cython.pymutex mutex
        Hacl_Hash_SHA1_state_t* state
    
    cpdef sha1 copy(self)
    cpdef str hexdigest(self)
    cpdef bytes digest(self)
    cdef void c_update(self, uint8_t* data, Py_ssize_t size)
    cpdef object update(self, object obj)
