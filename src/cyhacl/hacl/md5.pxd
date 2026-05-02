from libc.stdint cimport uint32_t as uint32_t
from libc.stdint cimport uint8_t as uint8_t

cdef extern from "Hacl_Hash_MD5.h" nogil:
    ctypedef uint8_t Hacl_Streaming_Types_error_code
    ctypedef struct Hacl_Streaming_MD_state_32:
        pass
    ctypedef Hacl_Streaming_MD_state_32 Hacl_Hash_MD5_state_t
    Hacl_Streaming_MD_state_32* Hacl_Hash_MD5_malloc()
    void Hacl_Hash_MD5_reset(Hacl_Streaming_MD_state_32* state)
    Hacl_Streaming_Types_error_code Hacl_Hash_MD5_update(Hacl_Streaming_MD_state_32* state, uint8_t* chunk, uint32_t chunk_len)
    void Hacl_Hash_MD5_digest(Hacl_Streaming_MD_state_32* state, uint8_t* output)
    void Hacl_Hash_MD5_free(Hacl_Streaming_MD_state_32* state)
    Hacl_Streaming_MD_state_32* Hacl_Hash_MD5_copy(Hacl_Streaming_MD_state_32* state)
    void Hacl_Hash_MD5_hash(uint8_t* output, uint8_t* input, uint32_t input_len)
    