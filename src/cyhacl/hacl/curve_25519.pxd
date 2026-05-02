from libc.stdint cimport uint8_t as uint8_t

cdef extern from "Hacl_Curve25519_51.h" nogil:
    void Hacl_Curve25519_51_scalarmult(uint8_t* out, uint8_t* priv, uint8_t* pub)
    void Hacl_Curve25519_51_secret_to_public(uint8_t* pub, uint8_t* priv)
    bint Hacl_Curve25519_51_ecdh(uint8_t* out, uint8_t* priv, uint8_t* pub)

cdef extern from "Hacl_Curve25519_64.h" nogil:
    void Hacl_Curve25519_64_scalarmult(uint8_t* out, uint8_t* priv, uint8_t* pub)
    void Hacl_Curve25519_64_secret_to_public(uint8_t* pub, uint8_t* priv)
    bint Hacl_Curve25519_64_ecdh(uint8_t* out, uint8_t* priv, uint8_t* pub)

