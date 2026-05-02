from libc.stdint cimport uint32_t as uint32_t
from libc.stdint cimport uint64_t as uint64_t
from libc.stdint cimport uint8_t as uint8_t

cdef extern from "Hacl_Hash_Blake2b.h" nogil:
    ctypedef uint8_t Hacl_Streaming_Types_error_code
    struct Hacl_Hash_Blake2b_state_t_s:
        pass
    struct Hacl_Hash_Blake2b_block_state_t_s:
        pass
    struct Hacl_Hash_Blake2b_blake2_params_s:
        uint8_t digest_length
        uint8_t key_length
        uint8_t fanout
        uint8_t depth
        uint32_t leaf_length
        uint64_t node_offset
        uint8_t node_depth
        uint8_t inner_length
        uint8_t* salt
        uint8_t* personal
    ctypedef Hacl_Hash_Blake2b_blake2_params_s Hacl_Hash_Blake2b_blake2_params
    struct Hacl_Hash_Blake2b_index_s:
        uint8_t key_length
        uint8_t digest_length
        bint last_node
    ctypedef Hacl_Hash_Blake2b_index_s Hacl_Hash_Blake2b_index
    ctypedef Hacl_Hash_Blake2b_block_state_t_s Hacl_Hash_Blake2b_block_state_t
    ctypedef Hacl_Hash_Blake2b_state_t_s Hacl_Hash_Blake2b_state_t
    Hacl_Hash_Blake2b_state_t* Hacl_Hash_Blake2b_malloc_with_params_and_key(Hacl_Hash_Blake2b_blake2_params* p, bint last_node, uint8_t* k)  
    Hacl_Hash_Blake2b_state_t* Hacl_Hash_Blake2b_malloc_with_key(uint8_t* k, uint8_t kk)
    Hacl_Hash_Blake2b_state_t* Hacl_Hash_Blake2b_malloc()
    void Hacl_Hash_Blake2b_reset_with_key_and_params(Hacl_Hash_Blake2b_state_t* s, Hacl_Hash_Blake2b_blake2_params* p, uint8_t* k)
    void Hacl_Hash_Blake2b_reset_with_key(Hacl_Hash_Blake2b_state_t* s, uint8_t* k)
    void Hacl_Hash_Blake2b_reset(Hacl_Hash_Blake2b_state_t* s)
    Hacl_Streaming_Types_error_code Hacl_Hash_Blake2b_update(Hacl_Hash_Blake2b_state_t* state, uint8_t* chunk, uint32_t chunk_len)
    uint8_t Hacl_Hash_Blake2b_digest(Hacl_Hash_Blake2b_state_t* s, uint8_t* dst)
    Hacl_Hash_Blake2b_index Hacl_Hash_Blake2b_info(Hacl_Hash_Blake2b_state_t* s)
    void Hacl_Hash_Blake2b_free(Hacl_Hash_Blake2b_state_t* state)
    Hacl_Hash_Blake2b_state_t* Hacl_Hash_Blake2b_copy(Hacl_Hash_Blake2b_state_t* state)
    void Hacl_Hash_Blake2b_hash_with_key(uint8_t* output, uint32_t output_len, uint8_t* input, uint32_t input_len, uint8_t* key, uint32_t key_len)
    void Hacl_Hash_Blake2b_hash_with_key_and_params(uint8_t* output, uint8_t* input, uint32_t input_len, Hacl_Hash_Blake2b_blake2_params params, uint8_t* key)
