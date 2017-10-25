This is basically a port of ZX7 by Einar Saukas

http://www.worldofspectrum.org/infoseekid.cgi?id=0027996

Follow the file example.X68. Assembled and executed with easy68k. The decrounching
algorithm is backwards so load A0 and A1 pointing to the end of the compressed
and uncompressed buffers respectively.

There are 3 version of decrunchers. I put the cycles decrounching a small file by
reference.

        Length      Cycles
slow    58 bytes    162328
medium  128 bytes   90766
fast    264 bytes   80962

Created by Antonio José Villena Godoy, 2017
Creative Commons Licensed by SA
https://creativecommons.org/licenses/by-sa/4.0/legalcode
