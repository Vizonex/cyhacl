# CyHACL
A rewrite of PyHACL with a few structural rewrite changes 
along with better low-level features including but not limited to

- A C-API Capsule
- cimportable modules
- Better structural changes (pure cython language instread of pythonized cython).

```python
from cyhacl.hashlib import sha256

s = sha256(b"Vizonex")
print(s.hexdigest())
print(s.digest())
```
