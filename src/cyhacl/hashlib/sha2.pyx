cimport cython
from cpython.buffer cimport PyBuffer_Release
from cpython.bytes cimport PyBytes_FromStringAndSize
from cpython.unicode cimport PyUnicode_FromStringAndSize
from libc.stdint cimport UINT32_MAX, uint8_t, uint32_t

from ..compat cimport GIL_MIN_SIZE, IS_64BIT, cyhacl_strhex, get_buffer_view
from ..hacl.sha2 cimport *

DEF SHA256_BLOCKSIZE  = 32
DEF SHA256_DIGESTSIZE = 64
DEF SHA512_BLOCKSIZE  = 64
DEF SHA512_DIGESTSIZE = 128

cdef void update_224(Hacl_Hash_SHA2_state_t_224* state, uint8_t* buf, Py_ssize_t size) noexcept nogil:
    if IS_64BIT:
        while size > UINT32_MAX:
            Hacl_Hash_SHA2_update_224(state, buf, UINT32_MAX)
            size -= UINT32_MAX
            buf += UINT32_MAX
    Hacl_Hash_SHA2_update_224(state, buf, <uint32_t>size)

cdef void update_256(Hacl_Hash_SHA2_state_t_256* state, uint8_t* buf, Py_ssize_t size) noexcept nogil:
    if IS_64BIT:
        while size > UINT32_MAX:
            Hacl_Hash_SHA2_update_256(state, buf, UINT32_MAX)
            size -= UINT32_MAX
            buf += UINT32_MAX
    Hacl_Hash_SHA2_update_256(state, buf, <uint32_t>size)

cdef void update_384(Hacl_Hash_SHA2_state_t_384* state, uint8_t* buf, Py_ssize_t size) noexcept nogil:
    if IS_64BIT:
        while size > UINT32_MAX:
            Hacl_Hash_SHA2_update_384(state, buf, UINT32_MAX)
            size -= UINT32_MAX
            buf += UINT32_MAX
    Hacl_Hash_SHA2_update_384(state, buf, <uint32_t>size)

cdef void update_512(Hacl_Hash_SHA2_state_t_512* state, uint8_t* buf, Py_ssize_t size) noexcept nogil:
    if IS_64BIT:
        while size > UINT32_MAX:
            Hacl_Hash_SHA2_update_512(state, buf, UINT32_MAX)
            size -= UINT32_MAX
            buf += UINT32_MAX
    Hacl_Hash_SHA2_update_512(state, buf, <uint32_t>size)



cdef class sha224:

    def __init__(self, object data = b'', object useforsecurity = True) -> None:
        """Return a new SHA224 hash object."""    
        self.state = Hacl_Hash_SHA2_malloc_224()
        if self.state == NULL:
            raise MemoryError
        if data:
            self.update(data)
    
    def __dealloc__(self):
        if self.state != NULL:
            Hacl_Hash_SHA2_free_224(self.state)
    
    @property
    def digest_size(self) -> int:
        return SHA256_BLOCKSIZE
    
    @property
    def block_size(self) -> int:
        return SHA256_DIGESTSIZE

    @property
    def name(self) -> str:
        return PyUnicode_FromStringAndSize("sha224", 6)
    
    cpdef sha224 copy(self):
        """Return a copy of the hash object."""
        cdef sha224 obj = sha224.__new__(sha224)  
        with self.mutex:
            obj.state = Hacl_Hash_SHA2_copy_256(self.state)
        if obj.state == NULL:
            del obj
            raise MemoryError()
        return obj

    cpdef str hexdigest(self):
        cdef uint8_t digest[SHA256_BLOCKSIZE]
        with self.mutex:
            Hacl_Hash_SHA2_digest_224(self.state, digest)
        return cyhacl_strhex(<const char*>digest, SHA256_BLOCKSIZE)

    cpdef bytes digest(self):
        cdef uint8_t digest[SHA256_BLOCKSIZE]
        with self.mutex:
            Hacl_Hash_SHA2_digest_224(self.state, digest)
        return PyBytes_FromStringAndSize(<char*>digest, SHA256_BLOCKSIZE)

    # Cython/C-API, This function should (almost) always succeed.
    cdef void c_update(self, uint8_t* data, Py_ssize_t size):
        cdef Hacl_Hash_SHA2_state_t_224* state = self.state
        # Same as HASHLIB_EXTERNAL_INSTRUCTIONS_LOCKED btw...
        with self.mutex:
            if (size > GIL_MIN_SIZE):
                with nogil:
                    update_224(state, data, size)
            else:
                update_224(state, data, size)

    cpdef object update(self, object obj):
        """Update this has object's state with the provided string."""
        cdef Py_buffer view
        if get_buffer_view(obj, &view) < 0:
            raise
        try:
            self.c_update(<uint8_t*>view.buf, view.len)
        finally:
            PyBuffer_Release(&view)
    

cdef class sha256:

    def __init__(self, object data = b'', object useforsecurity = True) -> None:
        """Return a new SHA256 hash object."""    
        self.state = Hacl_Hash_SHA2_malloc_256()
        if self.state == NULL:
            raise MemoryError
        if data:
            self.update(data)
    
    def __dealloc__(self):
        if self.state != NULL:
            Hacl_Hash_SHA2_free_256(self.state)
    
    @property
    def digest_size(self) -> int:
        return SHA256_BLOCKSIZE
    
    @property
    def block_size(self) -> int:
        return SHA256_DIGESTSIZE

    @property
    def name(self) -> str:
        return PyUnicode_FromStringAndSize("sha256", 6)
    
    cpdef sha256 copy(self):
        """Return a copy of the hash object."""
        cdef sha256 obj = sha256.__new__(sha256)  
        with self.mutex:
            obj.state = Hacl_Hash_SHA2_copy_256(self.state)
        if obj.state == NULL:
            del obj
            raise MemoryError()
        return obj

    cpdef str hexdigest(self):
        cdef uint8_t digest[SHA256_BLOCKSIZE]
        with self.mutex:
            Hacl_Hash_SHA2_digest_256(self.state, digest)
        return cyhacl_strhex(<const char*>digest, SHA256_BLOCKSIZE)

    cpdef bytes digest(self):
        cdef uint8_t digest[SHA256_BLOCKSIZE]
        with self.mutex:
            Hacl_Hash_SHA2_digest_256(self.state, digest)
        return PyBytes_FromStringAndSize(<char*>digest, SHA256_BLOCKSIZE)

    # Cython/C-API, This function should (almost) always succeed.
    cdef void c_update(self, uint8_t* data, Py_ssize_t size):
        cdef Hacl_Hash_SHA2_state_t_256* state = self.state
        # Same as HASHLIB_EXTERNAL_INSTRUCTIONS_LOCKED btw...
        with self.mutex:
            if (size > GIL_MIN_SIZE):
                with nogil:
                    update_256(state, data, size)
            else:
                update_256(state, data, size)

    cpdef object update(self, object obj):
        """Update this has object's state with the provided string."""
        cdef Py_buffer view
        if get_buffer_view(obj, &view) < 0:
            raise
        try:
            self.c_update(<uint8_t*>view.buf, view.len)
        finally:
            PyBuffer_Release(&view)


cdef class sha384:

    def __init__(self, object data = b'', object useforsecurity = True) -> None:
        """Return a new SHA384 hash object."""    
        self.state = Hacl_Hash_SHA2_malloc_384()
        if self.state == NULL:
            raise MemoryError
        if data:
            self.update(data)
    
    def __dealloc__(self):
        if self.state != NULL:
            Hacl_Hash_SHA2_free_384(self.state)
    
    @property
    def digest_size(self) -> int:
        return SHA512_BLOCKSIZE
    
    @property
    def block_size(self) -> int:
        return SHA512_DIGESTSIZE

    @property
    def name(self) -> str:
        return PyUnicode_FromStringAndSize("sha384", 6)
    
    cpdef sha384 copy(self):
        """Return a copy of the hash object."""
        cdef sha384 obj = sha384.__new__(sha384)  
        with self.mutex:
            obj.state = Hacl_Hash_SHA2_copy_512(self.state)
        if obj.state == NULL:
            del obj
            raise MemoryError()
        return obj

    cpdef str hexdigest(self):
        cdef uint8_t digest[SHA512_BLOCKSIZE]
        with self.mutex:
            Hacl_Hash_SHA2_digest_384(self.state, digest)
        return cyhacl_strhex(<const char*>digest, SHA512_BLOCKSIZE)

    cpdef bytes digest(self):
        cdef uint8_t digest[SHA512_BLOCKSIZE]
        with self.mutex:
            Hacl_Hash_SHA2_digest_384(self.state, digest)
        return PyBytes_FromStringAndSize(<char*>digest, SHA512_BLOCKSIZE)

    # Cython/C-API, This function should (almost) always succeed.
    cdef void c_update(self, uint8_t* data, Py_ssize_t size):
        cdef Hacl_Hash_SHA2_state_t_384* state = self.state
        # Same as HASHLIB_EXTERNAL_INSTRUCTIONS_LOCKED btw...
        with self.mutex:
            if (size > GIL_MIN_SIZE):
                with nogil:
                    update_384(state, data, size)
            else:
                update_384(state, data, size)

    cpdef object update(self, object obj):
        """Update this has object's state with the provided string."""
        cdef Py_buffer view
        if get_buffer_view(obj, &view) < 0:
            raise
        try:
            self.c_update(<uint8_t*>view.buf, view.len)
        finally:
            PyBuffer_Release(&view)

cdef class sha512:

    def __init__(self, object data = b'', object useforsecurity = True) -> None:
        """Return a new SHA512 hash object."""    
        self.state = Hacl_Hash_SHA2_malloc_512()
        if self.state == NULL:
            raise MemoryError
        if data:
            self.update(data)
    
    def __dealloc__(self):
        if self.state != NULL:
            Hacl_Hash_SHA2_free_512(self.state)
    
    @property
    def digest_size(self) -> int:
        return SHA512_BLOCKSIZE
    
    @property
    def block_size(self) -> int:
        return SHA512_DIGESTSIZE

    @property
    def name(self) -> str:
        return PyUnicode_FromStringAndSize("sha512", 6)
    
    cpdef sha512 copy(self):
        """Return a copy of the hash object."""
        cdef sha512 obj = sha512.__new__(sha512)  
        with self.mutex:
            obj.state = Hacl_Hash_SHA2_copy_512(self.state)
        if obj.state == NULL:
            del obj
            raise MemoryError()
        return obj

    cpdef str hexdigest(self):
        cdef uint8_t digest[SHA512_BLOCKSIZE]
        with self.mutex:
            Hacl_Hash_SHA2_digest_512(self.state, digest)
        return cyhacl_strhex(<const char*>digest, SHA512_BLOCKSIZE)

    cpdef bytes digest(self):
        cdef uint8_t digest[SHA512_BLOCKSIZE]
        with self.mutex:
            Hacl_Hash_SHA2_digest_512(self.state, digest)
        return PyBytes_FromStringAndSize(<char*>digest, SHA512_BLOCKSIZE)

    # Cython/C-API, This function should (almost) always succeed.
    cdef void c_update(self, uint8_t* data, Py_ssize_t size):
        cdef Hacl_Hash_SHA2_state_t_512* state = self.state
        # Same as HASHLIB_EXTERNAL_INSTRUCTIONS_LOCKED btw...
        with self.mutex:
            if (size > GIL_MIN_SIZE):
                with nogil:
                    update_512(state, data, size)
            else:
                update_512(state, data, size)

    cpdef object update(self, object obj):
        """Update this has object's state with the provided string."""
        cdef Py_buffer view
        if get_buffer_view(obj, &view) < 0:
            raise
        try:
            self.c_update(<uint8_t*>view.buf, view.len)
        finally:
            PyBuffer_Release(&view)


