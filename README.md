# Crc16

  Brings result of CRC calculation.

  Polynom: CRC-16-CCITT (x^16 + x^12 + x^5 + 1) or 0x1021.

  Calculates 16-bit CRC for given package.


  If package contains 16-bit CRC as its tail, returns 0x0000
  in case of package is error free.
