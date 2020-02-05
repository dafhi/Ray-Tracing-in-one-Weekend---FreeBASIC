/' -- "fb 1337 h4x.bas" - 2020 Jan 28 - by dafhi -- '/

#Ifndef FB_1337_H4XH
#define FB_1337_H4XH

#undef int
#define def   #define

def int     as Integer
def sng     as single
def dbl     as double
def bool    as boolean

def decl    declare
def virt    virtual
def func    function
def prop    property
def oper    operator
def csr     constructor
def ret     return
def float   single
def ac      as const

#undef color

function c255(in sng) int  '2020 Jan 22
  return iif( in<0, 0, iif( in>=1, 255, sqr(in)*256-.5 ) )
end function

#macro show_pixel( _col )
  scope
    var c = _col
    var ir = c255( c[0] )
    var ig = c255( c[1] )
    var ib = c255( c[2] )
    pset (i,ny-1-j), rgb( ir, ig, ib )
  end scope
#EndMacro

#undef rnd

function rnd as double
  static as ulong a, b
  a *= a
  a xor= b
  b += 1:  return a / culng(-1)
End Function

#endif
' -------- fb 1337 h4x
