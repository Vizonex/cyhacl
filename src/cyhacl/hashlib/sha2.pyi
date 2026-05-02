
import sys

if sys.version_info <= (3, 11):
    from typing_extensions import Buffer
else:
    from collections.abc import Buffer



class sha224:
    def __init__(self, data: Buffer = ..., useforsecurity: object = ...) -> None:
        """Return a new SHA224 hash object."""
        ...
    
    @property
    def digest_size(self) -> int:
        ...
    
    @property
    def block_size(self) -> int:
        ...
    
    @property
    def name(self) -> str:
        ...
    
    def copy(self) -> sha224:
        """Return a copy of the hash object."""
        ...
    
    def hexdigest(self) -> str:
        ...
    
    def digest(self) -> bytes:
        ...
    
    def update(self, obj: object) -> None:
        """Update this has object's state with the provided string."""
        ...
    


class sha256:
    def __init__(self, data: Buffer = ..., useforsecurity: object = ...) -> None:
        """Return a new SHA256 hash object."""
        ...
    
    @property
    def digest_size(self) -> int:
        ...
    
    @property
    def block_size(self) -> int:
        ...
    
    @property
    def name(self) -> str:
        ...
    
    def copy(self) -> sha256:
        """Return a copy of the hash object."""
        ...
    
    def hexdigest(self) -> str:
        ...
    
    def digest(self) -> bytes:
        ...
    
    def update(self, obj: object) -> None:
        """Update this has object's state with the provided string."""
        ...
    


class sha384:
    def __init__(self, data: Buffer = ..., useforsecurity: object = ...) -> None:
        """Return a new SHA384 hash object."""
        ...
    
    @property
    def digest_size(self) -> int:
        ...
    
    @property
    def block_size(self) -> int:
        ...
    
    @property
    def name(self) -> str:
        ...
    
    def copy(self) -> sha384:
        """Return a copy of the hash object."""
        ...
    
    def hexdigest(self) -> str:
        ...
    
    def digest(self) -> bytes:
        ...
    
    def update(self, obj: object) -> None:
        """Update this has object's state with the provided string."""
        ...
    


class sha512:
    def __init__(self, data: Buffer = ..., useforsecurity: object = ...) -> None:
        """Return a new SHA512 hash object."""
        ...
    
    @property
    def digest_size(self) -> int:
        ...
    
    @property
    def block_size(self) -> int:
        ...
    
    @property
    def name(self) -> str:
        ...
    
    def copy(self) -> sha512:
        """Return a copy of the hash object."""
        ...
    
    def hexdigest(self) -> str:
        ...
    
    def digest(self) -> bytes:
        ...
    
    def update(self, obj: object) -> None:
        """Update this has object's state with the provided string."""
        ...
    


