from libc.stdint cimport uint32_t as uint32_t
from libc.stdint cimport uint8_t as uint8_t

cdef extern from "Hacl_P256.h" nogil:
    bint Hacl_P256_ecdsa_sign_p256_sha2(uint8_t* signature, uint32_t msg_len, uint8_t* msg, uint8_t* private_key, uint8_t* nonce)
    bint Hacl_P256_ecdsa_sign_p256_sha384(uint8_t* signature, uint32_t msg_len, uint8_t* msg, uint8_t* private_key, uint8_t* nonce)
    bint Hacl_P256_ecdsa_sign_p256_sha512(uint8_t* signature, uint32_t msg_len, uint8_t* msg, uint8_t* private_key, uint8_t* nonce)
    bint Hacl_P256_ecdsa_sign_p256_without_hash(uint8_t* signature, uint32_t msg_len, uint8_t* msg, uint8_t* private_key, uint8_t* nonce)    
    bint Hacl_P256_ecdsa_verif_p256_sha2(uint32_t msg_len, uint8_t* msg, uint8_t* public_key, uint8_t* signature_r, uint8_t* signature_s)    
    bint Hacl_P256_ecdsa_verif_p256_sha384(uint32_t msg_len, uint8_t* msg, uint8_t* public_key, uint8_t* signature_r, uint8_t* signature_s)  
    bint Hacl_P256_ecdsa_verif_p256_sha512(uint32_t msg_len, uint8_t* msg, uint8_t* public_key, uint8_t* signature_r, uint8_t* signature_s)  
    bint Hacl_P256_ecdsa_verif_without_hash(uint32_t msg_len, uint8_t* msg, uint8_t* public_key, uint8_t* signature_r, uint8_t* signature_s) 
    bint Hacl_P256_validate_public_key(uint8_t* public_key)
    bint Hacl_P256_validate_private_key(uint8_t* private_key)
    bint Hacl_P256_uncompressed_to_raw(uint8_t* pk, uint8_t* pk_raw)
    bint Hacl_P256_compressed_to_raw(uint8_t* pk, uint8_t* pk_raw)
    void Hacl_P256_raw_to_uncompressed(uint8_t* pk_raw, uint8_t* pk)
    void Hacl_P256_raw_to_compressed(uint8_t* pk_raw, uint8_t* pk)
    bint Hacl_P256_dh_initiator(uint8_t* public_key, uint8_t* private_key)
    bint Hacl_P256_dh_responder(uint8_t* shared_secret, uint8_t* their_pubkey, uint8_t* private_key)

