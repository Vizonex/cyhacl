from libc.stdint cimport uint32_t as uint32_t
from libc.stdint cimport uint8_t as uint8_t

cdef extern from "Hacl_HMAC.h" nogil:
    void Hacl_HMAC_compute_md5(uint8_t* dst, uint8_t* key, uint32_t key_len, uint8_t* data, uint32_t data_len)
    void Hacl_HMAC_compute_sha1(uint8_t* dst, uint8_t* key, uint32_t key_len, uint8_t* data, uint32_t data_len)
    void Hacl_HMAC_compute_sha2_224(uint8_t* dst, uint8_t* key, uint32_t key_len, uint8_t* data, uint32_t data_len)
    void Hacl_HMAC_compute_sha2_256(uint8_t* dst, uint8_t* key, uint32_t key_len, uint8_t* data, uint32_t data_len)
    void Hacl_HMAC_compute_sha2_384(uint8_t* dst, uint8_t* key, uint32_t key_len, uint8_t* data, uint32_t data_len)
    void Hacl_HMAC_compute_sha2_512(uint8_t* dst, uint8_t* key, uint32_t key_len, uint8_t* data, uint32_t data_len)
    void Hacl_HMAC_compute_sha3_224(uint8_t* dst, uint8_t* key, uint32_t key_len, uint8_t* data, uint32_t data_len)
    void Hacl_HMAC_compute_sha3_256(uint8_t* dst, uint8_t* key, uint32_t key_len, uint8_t* data, uint32_t data_len)
    void Hacl_HMAC_compute_sha3_384(uint8_t* dst, uint8_t* key, uint32_t key_len, uint8_t* data, uint32_t data_len)
    void Hacl_HMAC_compute_sha3_512(uint8_t* dst, uint8_t* key, uint32_t key_len, uint8_t* data, uint32_t data_len)
    void Hacl_HMAC_compute_blake2s_32(uint8_t* dst, uint8_t* key, uint32_t key_len, uint8_t* data, uint32_t data_len)
    void Hacl_HMAC_compute_blake2b_32(uint8_t* dst, uint8_t* key, uint32_t key_len, uint8_t* data, uint32_t data_len)