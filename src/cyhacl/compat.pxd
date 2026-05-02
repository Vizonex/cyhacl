cdef extern from "compat.h":
    # used checking to see if hashing can do higher loads.
    bint IS_64BIT "CYHACL_IS_64BIT"

    # Same as _Py_hashlib_get_buffer_view
    int get_buffer_view "cyhacl_get_buffer_view"(object obj, Py_buffer *view) except -1
    # returns a unicode object in hex form.
    object cyhacl_strhex(const char *argbuf, const Py_ssize_t arglen)

    # Describes when GIL Should Release
    # when attempting to perform hash 
    # operations.
    Py_ssize_t GIL_MIN_SIZE
