cimport cython
from cpython.buffer cimport PyBuffer_Release
from cpython.bytes cimport PyBytes_FromStringAndSize
from cpython.unicode cimport PyUnicode_FromStringAndSize
from libc.stdint cimport UINT32_MAX, uint8_t, uint32_t

from ..compat cimport GIL_MIN_SIZE, IS_64BIT, cyhacl_strhex, get_buffer_view
from ..hacl.sha1 cimport *

DEF SHA1_BLOCKSIZE = 64
DEF SHA1_DIGESTSIZE = 20


# it was the easiet way to mimic the newer hashlib and still release the gil. 
cdef void update(Hacl_Hash_SHA1_state_t* state, uint8_t* buf, Py_ssize_t size) noexcept nogil:
    if IS_64BIT:
        while size > UINT32_MAX:
            Hacl_Hash_SHA1_update(state, buf, UINT32_MAX)
            size -= UINT32_MAX
            buf += UINT32_MAX
    Hacl_Hash_SHA1_update(state, buf, <uint32_t>size)




    
cdef class sha1:
    """uses the sha1 hashing algorythm."""

    # NOTE: string object is deprecated in standard hashlib so it's not used.
    def __init__(self, object data = b'', object useforsecurity = True) -> None:
        """Return a new SHA1 hash object."""    
        self.state = Hacl_Hash_SHA1_malloc()
        if self.state == NULL:
            raise MemoryError
        if data:
            self.update(data)
    
    def __dealloc__(self):
        if self.state != NULL:
            Hacl_Hash_SHA1_free(self.state)
    
    @property
    def digest_size(self) -> int:
        return SHA1_DIGESTSIZE
    
    @property
    def block_size(self) -> int:
        return SHA1_BLOCKSIZE

    @property
    def name(self) -> str:
        return PyUnicode_FromStringAndSize("sha1", 4)
    
    cpdef sha1 copy(self):
        """Return a copy of the hash object."""
        cdef sha1 obj = sha1.__new__(sha1)  
        with self.mutex:
            obj.state = Hacl_Hash_SHA1_copy(self.state)
        if obj.state == NULL:
            del obj
            raise MemoryError()
        return obj

    cpdef str hexdigest(self):
        cdef uint8_t digest[SHA1_DIGESTSIZE]
        with self.mutex:
            Hacl_Hash_SHA1_digest(self.state, digest)
        return cyhacl_strhex(<const char*>digest, SHA1_DIGESTSIZE)

    cpdef bytes digest(self):
        cdef uint8_t digest[SHA1_DIGESTSIZE]
        with self.mutex:
            Hacl_Hash_SHA1_digest(self.state, digest)
        return PyBytes_FromStringAndSize(<char*>digest, SHA1_DIGESTSIZE)

    # Cython/C-API, This function should (almost) always succeed.
    cdef void c_update(self, uint8_t* data, Py_ssize_t size):
        cdef Hacl_Hash_SHA1_state_t* state = self.state
        # Same as HASHLIB_EXTERNAL_INSTRUCTIONS_LOCKED btw...
        with self.mutex:
            if (size > GIL_MIN_SIZE):
                with nogil:
                    update(state, data, size)
            else:
                update(state, data, size)

    cpdef object update(self, object obj):
        """Update this has object's state with the provided string."""
        cdef Py_buffer view
        if get_buffer_view(obj, &view) < 0:
            raise
        try:
            self.c_update(<uint8_t*>view.buf, view.len)
        finally:
            PyBuffer_Release(&view)

# Mimic of sha1module.c
_GIL_MINSIZE = GIL_MIN_SIZE

