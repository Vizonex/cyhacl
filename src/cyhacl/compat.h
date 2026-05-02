#ifndef __COMPAT_H__
#define __COMPAT_H__

#if defined (__cplusplus)
extern "C" {
#endif

#include "Python.h"
#include <stdint.h>

/* MACROS */
#if (PY_SSIZE_T_MAX > UINT32_MAX)
    #define CYHACL_IS_64BIT 1
#else
    #define CYHACL_IS_64BIT 0
#endif



#ifndef Py_INTERNAL_STRHEX_H
/* Same as _Py_hexlify_scalar seen in pystrhex.c 
(Some users may not have the luxury of large diskspace or access to the full 
cpython internals), NOTE: YES ITS THREADSAFE!!!
*/
const char *cyhacl_hexdigits = "0123456789abcdef";

static inline void 
_cyhacl_hexlify_scalar(const unsigned char *src, Py_UCS1 *dst, Py_ssize_t len){
    for (Py_ssize_t i = 0; i < len; i++) {
        unsigned char c = src[i];
        *dst++ = cyhacl_hexdigits[c >> 4];
        *dst++ = cyhacl_hexdigits[c & 0x0f];
    }
}

/* This is a smaller cookie-cut version of _Py_strhex_impl(...) */
static PyObject* cyhacl_strhex(const char* argbuf, const Py_ssize_t arglen){
    Py_ssize_t result_len = arglen * 2;
    PyObject* hex_obj = PyUnicode_New(result_len, 127);
    if (!hex_obj){
        return NULL;
    }
    Py_UCS1* dst = PyUnicode_1BYTE_DATA(hex_obj);
    _cyhacl_hexlify_scalar((const unsigned char*)argbuf, dst, arglen);
    return hex_obj;
}
#else
// If somehow someone manages to get a hold of the _Py_strhex function it goes here...
#define cyhacl_strhex(argbuf, arglen) _Py_strhex(argbuf, arglen);
#endif

/* static INLINED Functions */

/* Mirrors Py_hashlib_get_buffer_veiw part of cpython 3.15's hashlib.h file */

static inline int 
cyhacl_get_buffer_view(PyObject* obj, Py_buffer *view){
    if (PyUnicode_Check(obj)) {
        PyErr_SetString(PyExc_TypeError,
                        "Strings must be encoded before hashing");
        return -1;
    }
    if (!PyObject_CheckBuffer(obj)) {
        PyErr_SetString(PyExc_TypeError,
                        "object supporting the buffer API required");
        return -1;
    }
    if (PyObject_GetBuffer(obj, view, PyBUF_SIMPLE) == -1) {
        return -1;
    }
    if (view->ndim > 1) {
        PyErr_SetString(PyExc_BufferError,
                        "Buffer must be single dimension");
        PyBuffer_Release(view);
        return -1;
    }
    return 0;
}



#define GIL_MIN_SIZE 2048




#if defined (__cplusplus)
}
#endif

#endif // __COMPAT_H__