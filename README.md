# openvdb-snow-leopard

Build the **OpenVDB** fork used by Bambu Studio (tamasmeszaros @a68fd58, "8.2
patched") as a **static i386 library for Mac OS X 10.6.8**.

```sh
./build.sh      # -> prefix/lib/libopenvdb.a (i386)
```

Notes:
- Uses the clang/`ld64-274` toolchain in `toolchain/` (the stock 10.6 `ld64-127`
  fails on clang-16 exception-unwind output).
- Applies upstream `0001-clang19.patch`; static core, no python, SIMD-agnostic.
- **Depends on** TBB, OpenEXR 2.x, c-blosc and Boost being installed under
  `prefix/` or `/opt/local` first (see the sibling `onetbb-`, `cblosc-` ports;
  OpenEXR/Boost via MacPorts or your own build).
