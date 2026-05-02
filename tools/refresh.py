#!/usr/bin/env python3

# This tool is used for updating hacl simillar to how python does it.
# However the developer has opted to use this to make it possible to 
# run on both linux and windows without fail. Some design choices were
# inspired by cherry-picker and is based off refresh.sh

from __future__ import annotations
import collections
from collections.abc import Sequence
import sys
import subprocess
import hashlib
import functools
import os
import shutil
import pathlib
import click
import glob

if sys.version_info >= (3, 11):
    import tomllib
else:
    import tomli as tomllib



class GitCloneException(Exception):
    def __init__(self, repo: str):
        self.repo = repo
        super().__init__(f"Error when cloning branch {repo!r}.")


class Hacl:
    def __init__(
        self, 
        hacl_directory: str | None = None, 
        config: dict[str, str] = {}, 
        dry_run: bool = False,  
        cwd: str | None = None
    ) -> None:
        self.dry_run = dry_run
        self.config = config
        self.hacl_dir = hacl_directory
        self.cwd = cwd or os.getcwd()

    
    def git_clone(self, repo_url: str, cwd: str | None = None):
        """git clone <repo_url> --recursive"""
        cmd = ["git", "clone", repo_url, "--recursive"]
        try:
            return self.run_cmd(cmd, cwd=cwd)
        except subprocess.CalledProcessError:
            raise GitCloneException(repo_url)

    def get_repos_sha1_hash(self, dir: str) -> str:
        """obtains a git repository's sha1 hash"""
        return self.run_cmd(["git", "rev-parse", "HEAD"], cwd=dir, required_real_result=True)

    # This part was from cherry-picker with a few adjustments made.
    def run_cmd(self, cmd: Sequence[str], required_real_result: bool = False, cwd: str | None = None):
        assert not isinstance(cmd, str)
        if not required_real_result and self.dry_run:
            click.echo(f"  dry-run: {' '.join(cmd)}")
            return
        output = subprocess.check_output(cmd, stderr=subprocess.STDOUT, cwd=cwd or self.cwd)
        return output.decode("utf-8")

    @functools.cached_property
    def dist_files(self):
        return [
            "Hacl_Streaming_Types.h",
            "internal/Hacl_Streaming_Types.h",
            # NOTE: There maybe more implementations coming soon
            # Such as Ed25519 or aes-gcm or randombuffer even though 
            # python has one.

            "Hacl_Hash_MD5.h",
            "Hacl_Hash_SHA1.h",
            "Hacl_Hash_SHA2.h",
            "Hacl_Hash_SHA3.h",
            "Hacl_Hash_Blake2b.h",
            "Hacl_Hash_Blake2s.h",
            "Hacl_Hash_Blake2b_Simd256.h",
            "Hacl_Hash_Blake2s_Simd128.h",

            # Crypto Primitives (HMAC)
            "Hacl_HMAC.h",
            "Hacl_Streaming_HMAC.h",

            # Internals...
            "internal/Hacl_Hash_MD5.h",
            "internal/Hacl_Hash_SHA1.h",
            "internal/Hacl_Hash_SHA2.h",
            "internal/Hacl_Hash_SHA3.h",
            "internal/Hacl_Hash_Blake2b.h",
            "internal/Hacl_Hash_Blake2s.h",
            "internal/Hacl_Hash_Blake2b_Simd256.h",
            "internal/Hacl_Hash_Blake2s_Simd128.h",
            "internal/Hacl_Impl_Blake2_Constants.h",
            "internal/Hacl_Krmllib.h",


            # HMAC Internals..
            "internal/Hacl_HMAC.h",
            "internal/Hacl_Streaming_HMAC.h",

            # Sources
            "Hacl_Hash_MD5.c",
            "Hacl_Hash_SHA1.c",
            "Hacl_Hash_SHA2.c",
            "Hacl_Hash_SHA3.c",
            "Hacl_Hash_Blake2b.c",
            "Hacl_Hash_Blake2s.c",
            "Hacl_Hash_Blake2b_Simd256.c",
            "Hacl_Hash_Blake2s_Simd128.c",

            # Cryptographic Primitives (HMAC Sources)
            "Hacl_HMAC.c",
            "Hacl_Streaming_HMAC.c",

            # Other, ideas came from pyhacl.
            "Hacl_Curve25519_51.c",
            "Hacl_Curve25519_51.h",
            "Hacl_Curve25519_64.c",
            "Hacl_Curve25519_64.h",
            "Hacl_AEAD_Chacha20Poly1305_Simd128.c",
            "Hacl_AEAD_Chacha20Poly1305_Simd128.h",
            "Hacl_AEAD_Chacha20Poly1305_Simd256.c",
            "Hacl_AEAD_Chacha20Poly1305_Simd256.h",
            "Hacl_P256.c",
            "Hacl_P256.h",

            "Hacl_Ed25519.c",
            "Hacl_Ed25519.h",



            # Misc
            "libintvector.h",
            "libintvector-shim.h",
            "lib_memzero0.h",
            "Lib_Memzero0.c",

            "Hacl_Krmllib.h",
            "lib_intrinsics.h",
            "Hacl_IntTypes_Intrinsics.h",
        ]

    @functools.cached_property
    def include_files(self):
        return [
            "include/krml/lowstar_endianness.h",
            "include/krml/internal/compat.h",
            "include/krml/internal/target.h",
            "include/krml/internal/types.h",
        ]
    
    @functools.cached_property
    def lib_files(self):
        return [
            "krmllib/dist/minimal/FStar_UInt_8_16_32_64.h",
            "krmllib/dist/minimal/fstar_uint128_struct_endianness.h",
            "krmllib/dist/minimal/FStar_UInt128_Verified.h"
        ]

    def dup(self, file: str | pathlib.Path, to:str | pathlib.Path):
        if not self.dry_run:
            shutil.copyfile(file, to)
        else:
            click.echo(f"  dry-run: {file} -> {to}")
    
    def sed(self, input: str | pathlib.Path, replacements: dict[str, str]) -> None:
        if self.dry_run:
            click.echo(f"  dry-run: replace {input} {replacements!r}")
            return
        i = pathlib.Path(input)
        data = i.read_text()
        for k, v in replacements.items():
            data = data.replace(k, v)
        i.write_text(data)

    def sed_many(self, inputs: list[str | pathlib.Path], replacements: dict[str, str]) -> None:
        for i in inputs:
            self.sed(i)

    def do_update(self) -> None:
        """
        Updates files to vendor portion simillar to python's newer hashlib.
        Hacl is big and with that we need to condense what we need and make changes to it.
        """
        if self.hacl_dir is None or not os.path.exists(self.hacl_dir):
            click.echo("Cloning HACL")
            self.git_clone("https://github.com/hacl-star/hacl-star", self.hacl_dir)
            # make existant
            self.hacl_dir = self.hacl_dir or "hacl-star"

        click.echo("Duplicating HACL Files")
        gcc = pathlib.Path(self.hacl_dir) / "dist" / "gcc-compatible"
        karamel = pathlib.Path(self.hacl_dir) / "dist" / "karamel"

        vendor = pathlib.Path("vendor")
        
        if not vendor.exists() and not self.dry_run:
            vendor.mkdir()
            (vendor / "internal").mkdir()
            (vendor / "include").mkdir()
            # vendor\\include\\krml
            (vendor / "include" / "krml").mkdir()
            (vendor / "include" / "krml" / "internal").mkdir()
            

        
        click.echo("gcc-compatable directory")
        for d in self.dist_files:
            self.dup(gcc / d, vendor / d)

        for d in self.include_files:
            self.dup(karamel / d, vendor / d)
        
        for f in self.lib_files:
            child = pathlib.Path(f).name
            self.dup(karamel / f, vendor / "include" / "krml" / child)

        # Adjust these files...
        self.sed(vendor / "include/krml/internal/types.h", {
            '#include "FStar_UInt128_Verified.h"': '#include "krml/FStar_UInt128_Verified.h"',
            '#include "fstar_uint128_struct_endianness.h"': '#include "krml/fstar_uint128_struct_endianness.h"',
            '#define KRML_TYPES_H':'#define KRML_TYPES_H\n#define KRML_VERIFIED_UINT128'})

        # self.sed_many(
        #     glob.glob(str(vendor / "Hacl_Hash_*.h")) + [
        #         vendor / "Hacl_HMAC.h", 
        #         vendor / "Hacl_Streaming_HMAC.h",
        #     ], {
        #         's!#include <string.h>!#include <string.h>\n#include "python_hacl_namespaces.h"'
        #     }
        # )
 
if __name__ == "__main__":
    Hacl(
        "hacl-star", dry_run=False
    ).do_update()


        









