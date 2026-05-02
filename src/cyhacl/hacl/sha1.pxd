# Mostly just an external part, but this was made due to some
# unfinished work with the abandoned cyright extension.

from libc.stdint cimport uint8_t, uint32_t


cdef extern from "Hacl_Hash_SHA1.h" nogil:
    ctypedef struct Hacl_Streaming_MD_state_32:
        pass

    ctypedef Hacl_Streaming_MD_state_32 Hacl_Hash_SHA1_state_t
    ctypedef uint8_t Hacl_Streaming_Types_error_code
    int Hacl_Hash_SHA1_update(Hacl_Streaming_MD_state_32 *state, uint8_t *chunk, uint32_t chunk_len)
    void Hacl_Hash_SHA1_digest(Hacl_Streaming_MD_state_32 *state, uint8_t *output)
    void Hacl_Hash_SHA1_free(Hacl_Streaming_MD_state_32 *state)
    Hacl_Streaming_MD_state_32 *Hacl_Hash_SHA1_copy(Hacl_Streaming_MD_state_32 *state)
    void Hacl_Hash_SHA1_hash(uint8_t *output, uint8_t *input, uint32_t input_len)
    Hacl_Streaming_MD_state_32 *Hacl_Hash_SHA1_malloc()

