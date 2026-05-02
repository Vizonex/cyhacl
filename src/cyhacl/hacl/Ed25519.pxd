from libc.stdint cimport uint32_t as uint32_t
from libc.stdint cimport uint8_t as uint8_t

cdef extern from "Hacl_Ed25519.h" nogil:
    void Hacl_Ed25519_secret_to_public(uint8_t* public_key, uint8_t* private_key)
    void Hacl_Ed25519_expand_keys(uint8_t* expanded_keys, uint8_t* private_key)
    void Hacl_Ed25519_sign_expanded(uint8_t* signature, uint8_t* expanded_keys, uint32_t msg_len, uint8_t* msg)
    void Hacl_Ed25519_sign(uint8_t* signature, uint8_t* private_key, uint32_t msg_len, uint8_t* msg)
    bint Hacl_Ed25519_verify(uint8_t* public_key, uint32_t msg_len, uint8_t* msg, uint8_t* signature)
    

