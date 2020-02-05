/' -- vec3.bas - 2020 Jan 28 - by dafhi  '/

#ifndef VEC3H
#define VEC3H

#include "fb 1337 h4x.bas"

#ifndef piBy4
const   Tau = 8*atn(1)
const   piBy4 = 4*atn(1)
#EndIf

const as float EPS=1e-6
const as float INF=1e9f

#define v3 _
  vec3


#if 1

  '' 2nd attempt - brought in from my path tracer.
  
  type vec3
    decl csr        ''constructor
    decl csr(sng=0, sng=0, sng=0)
    
    as single         x,y,z
    declare sub       norm
    decl const oper   [](int) byref as float
    declare property  len as single
    declare property  squared_length as single
    declare function  dot(byref as const v3 ptr) as single
    declare function  perp(in as single=1) as v3
    declare function  cross(in as v3, slen as single=1) as v3
    declare function  blend(in as v3, a as single=.5) as v3  '2017 Feb 14
    declare property  n as v3
  end type
  
  #define length            len
  #define make_unit_vector  norm
  #define unit_v            n
  
  csr v3: end csr
  csr v3(a sng, b sng, c sng): x=a: y=b: z=c: end csr
  
  const oper vec3.[](index int) byref as float
    ret cptr(float ptr,@x)[index]
  end oper

  property v3.n as v3
    dim as single s = x*x+y*y+z*z:  if s<>0 then s=1/sqr(s)
    return type(x*s,y*s,z*s)
  End Property
  
  function v3.blend(in as v3, a as single=.5) as v3
    return type( x + a*(in.x-x), y+a*(in.y-y), z+a*(in.z-z) )
  end function
  
  property v3.len as single: return sqr(x*x+y*y+z*z): end property
  
  function v3.dot(byref r as const v3 ptr) as single: return x*r->x+y*r->y+z*r->z: end function
  
  property v3.squared_length as single
    return x*x+y*y+z*z
  End Property
  
  function v3.perp(in as single) as v3
    if y=0 then return type(0, in, 0)
    var s=z*z+x*x: if s=0 then return type(in,0,0)
    s=in/sqr(s):  return type(z*s, 0, -x*s)
  End function
  
  function v3.cross(r as v3, slen as single) as v3
    static as single xx, yy, zz, s
    xx = y*r.z - z*r.y
    yy = z*r.x - x*r.z
    zz = x*r.y - y*r.x
    s = xx*xx+yy*yy+zz*zz: if s=0 then return type(0,0,0)
    s=slen/sqr(s):  return type(xx*s,yy*s,zz*s)
  End function
  
  sub v3.norm:  dim as single s=1/sqr(x*x+y*y+z*z): x*=s:y*=s:z*=s: end sub
  
  operator +(l as v3,r as v3) as v3: return type(l.x+r.x, l.y+r.y, l.z+r.z): end operator
  operator *(l as v3,r as single) as v3: return type(l.x*r,l.y*r,l.z*r): end operator
  operator -(r as v3) as v3: return type(-r.x, -r.y, -r.z): end operator
  operator -(l as v3,r as v3) as v3: return type(l.x-r.x,l.y-r.y,l.z-r.z): end operator
  operator /(l as v3,r as single) as v3: dim as single s = 1/r: return type(l.x*s,l.y*s,l.z*s): end operator
  operator *(l as single, r as v3) as v3: return type(l*r.x,l*r.y,l*r.z): end operator
  operator *(l as v3,r as v3) as v3: return type(l.x*r.x,l.y*r.y,l.z*r.z): end operator

#else
  
  '' First attempt (seems okay)
  
  type vec3
    
    decl csr(sng=0, sng=0, sng=0)
    decl csr(as vec3)
    
    decl const oper [](int) byref as float
    
    decl oper += (as vec3)
    decl oper -= (as vec3)
    decl oper *= (as vec3)
    decl oper /= (as vec3)
    decl oper *= (as float)
    decl oper /= (as float)
   
    decl prop unit_v as vec3
    decl prop length as float
    decl prop squared_length as float
    decl sub  make_unit_vector

    decl oper cast as string
    
    as float x, y, z
    
  End type

  csr vec3(xx sng, yy sng, zz sng)
    x=xx: y=yy: z=zz
  end csr

  csr vec3(i as vec3)
    x=i.x: y=i.y: z=i.z
  end csr

  oper vec3.cast as string
    return str(x)+" "+str(y)+" "+str(z)
  end oper

  const oper vec3.[](index int) byref as float
    ret cptr(float ptr,@x)[index]
  end oper

  oper vec3.*= (i as float)
    x *= i:  y *= i:  z *= i
  end oper

  oper vec3./= (i as float)
    i = 1/i
    x *= i:  y *= i:  z *= i
  end oper

  #macro _ops(op)
    oper vec3.op= ( byref rhs as vec3 )
      x op= rhs.x
      y op= rhs.y
      z op= rhs.z
    end oper
  #endmacro

  _ops(+)
  _ops(-)
  _ops(*)
  _ops(/)
  #undef _ops

  prop vec3.unit_v as vec3
    static as float s: s = x*x+y*y+z*z
    if s > EPS then s=1/sqr(s): return vec3(x*s,y*s,z*s)
    return this
  end prop

  prop vec3.squared_length as float
    return x*x+y*y+z*z
  end prop

  prop vec3.length as float
    return sqr(x*x+y*y+z*z)
  end prop

  sub vec3.make_unit_vector
    var k = x*x + y*y + z*z
    if k<>0 then k = 1/sqr(k):  x *= k: y *= k: z *= k
  end sub

  oper -(v as vec3) as vec3
    ret vec3(-v.x, -v.y, -v.z)
  end oper

  oper *(t as float, byref v as vec3) as vec3
      ret vec3( v.x * t, v.y * t, v.z * t )
  end oper

  oper *(byref v as vec3, t as float) as vec3
      ret vec3( v.x * t, v.y * t, v.z * t )
  end oper

  #macro _ops(op)
    oper op(l as vec3, r as vec3) as vec3
      oper = vec3(l.x op r.x,l.y op r.y,l.z op r.z)
    end oper
  #endmacro

  _ops(+)
  _ops(-)
  _ops(*)
  _ops(/)
  #undef _ops

  oper /(l as vec3,r as float) as vec3
    if ABS(r) < EPS then
      oper = l
    else
      r=1/r
      oper = l*r
    end if
  end oper

#endif


function unit_vector(v ac vec3) as vec3
  static as float s: s = v.x*v.x+v.y*v.y+v.z*v.z
  if s > EPS then s=1/sqr(s): return vec3(v.x*s,v.y*s,v.z*s)
  return type(1,0,0)
end function

func dot(byref v1 ac vec3, byref v2 ac vec3) as float
    ret v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
end func

func cross(byref v1 ac vec3, byref v2 ac vec3) as vec3
  ret v3( _
      v1.y*v2.z - v1.z*v2.y, _
      v1.z*v2.x - v1.x*v2.z, _
      v1.x*v2.y - v1.y*v2.x)
end func

#endif
' ------- vec3

/'
    declare function  rand(spread as single=1) as v3
  function v3.rand(spread as single) as v3 '2016 Dec 12
    dim as single cosa = 1-spread
    dim as single sina = sqr(1-cosa*cosa):  spread = rnd*tau
    dim as v3 perp0 = perp(cos(spread)*sina)
    return this*cosa + perp0 + cross(perp0, sin(spread)*sina)
  End function
'/