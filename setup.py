from setuptools import setup, Extension
from setuptools.command.build_ext import build_ext
from typing import Any, TYPE_CHECKING
import sys
from Cython.Build import cythonize

from pathlib import Path
if sys.version_info >= (3, 11):
    import tomllib
else:
    import tomli as tomllib

MODULE_PATH = Path("src") / "cyhacl"
VENDOR = Path("vendor")

def actual_path(data: str):
    return VENDOR / data

def extension_from_config(cfg: dict[str, Any], **kw) -> Extension:
    files : list[Path] = [ MODULE_PATH / cfg.pop('file')]
    # copy off all vendors
    print(cfg)
    files.extend(map(actual_path, cfg.pop('dep')))

    kwargs = {
        "name": cfg.pop('name'),
        # main file + other entries (C Files commonly)
        "sources": files,
        "include_dirs": ["vendor", "vendor/include/krml", "vendor/include"]
    }
    kwargs.update(kw)
    return Extension(**kwargs)


def load_extensions(**kw):
    with open("extensions.toml", "rb") as r:
        data: dict[str, list[dict[str, Any]]] = tomllib.load(r)['extensions']
    return cythonize([extension_from_config(f, **kw) for f in data['files']])


if __name__ == "__main__":
    setup(
        ext_modules=load_extensions()
    )


