#!/usr/local/bin/python3

import math
import struct
import sys

maps = {"QPSK": [1/math.sqrt(2),
                 -1/math.sqrt(2)],

        "QAM16": [1/math.sqrt(10), 3/math.sqrt(10),
                  -1/math.sqrt(10), -3/math.sqrt(10)],

        "QAM64": [1/math.sqrt(42), 3/math.sqrt(42), 5/math.sqrt(42), 7/math.sqrt(42),
                  -1/math.sqrt(42), -3/math.sqrt(42), -5/math.sqrt(42), -7/math.sqrt(42)]}

def float_to_hex(f):
    return hex(struct.unpack('<I', struct.pack('<f', f))[0])

for modulation, mappings in maps.items():
    hex_map = []

    print("  constant {0}_IQ_MAP : IQ_map_t(0 to 2**{0}_BITS - 1) :=".format(modulation), end="\n")

    for i in range(len(mappings)):
        hex_map.append("x\"%s\"" % float_to_hex(mappings[i])[2:])

    print("    (", end="")
    print(",\n     ".join(hex_map), end="")
    print(");")
