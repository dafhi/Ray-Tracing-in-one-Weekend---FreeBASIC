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

type vec3 '' brought in from my path tracer

   decl csr(sng=0, sng=0, sng=0)

   as float    x,y,z
   decl sub    norm
   decl const  oper   [](int) byref as float
   decl prop   len as float
   decl prop   squared_length as float
   decl func   dot(byref as const v3 ptr) as float
   decl func   perp(in as float=1) as v3
   decl func   cross(in as v3, slen as float=1) as v3
   decl func   blend(in as v3, a as float=.5) as v3  '2017 Feb 14
   decl prop   n as v3
end type

#define length            len
#define make_unit_vector  norm
#define unit_v            n

csr v3(a sng, b sng, c sng): x=a: y=b: z=c: end csr

const oper vec3.[](index int) byref as float
   ret cptr(float ptr,@x)[index]
end oper

prop v3.n as v3
   dim as float s = x*x+y*y+z*z:  if s<>0 then s=1/sqr(s)
   return type(x*s,y*s,z*s)
End prop

func v3.blend(in as v3, a as float=.5) as v3
   return type( x + a*(in.x-x), y+a*(in.y-y), z+a*(in.z-z) )
end func

prop v3.len as float: return sqr(x*x+y*y+z*z): end prop

func v3.dot(byref r as const v3 ptr) as float: return x*r->x+y*r->y+z*r->z: end func

prop v3.squared_length as float
   return x*x+y*y+z*z
End prop

func v3.perp(in as float) as v3
   if y=0 then return type(0, in, 0)
   var s=z*z+x*x: if s=0 then return type(in,0,0)
   s=in/sqr(s):  return type(z*s, 0, -x*s)
End func

func v3.cross(r as v3, slen as float) as v3
   static as float xx, yy, zz, s
   xx = y*r.z - z*r.y
   yy = z*r.x - x*r.z
   zz = x*r.y - y*r.x
   s = xx*xx+yy*yy+zz*zz: if s=0 then return type(0,0,0)
   s=slen/sqr(s):  return type(xx*s,yy*s,zz*s)
End func

sub v3.norm:  dim as float s=1/sqr(x*x+y*y+z*z): x*=s:y*=s:z*=s: end sub

oper +(l as v3,r as v3) as v3: return type(l.x+r.x, l.y+r.y, l.z+r.z): end oper
oper *(l as v3,r as float) as v3: return type(l.x*r,l.y*r,l.z*r): end oper
oper -(r as v3) as v3: return type(-r.x, -r.y, -r.z): end oper
oper -(l as v3,r as v3) as v3: return type(l.x-r.x,l.y-r.y,l.z-r.z): end oper
oper /(l as v3,r as float) as v3: dim as float s = 1/r: return type(l.x*s,l.y*s,l.z*s): end oper
oper *(l as float, r as v3) as v3: return type(l*r.x,l*r.y,l*r.z): end oper
oper *(l as v3,r as v3) as v3: return type(l.x*r.x,l.y*r.y,l.z*r.z): end oper

''
func unit_vector(v ac vec3) as vec3
   static as float s: s = v.x*v.x+v.y*v.y+v.z*v.z
   if s > EPS then s=1/sqr(s): return vec3(v.x*s,v.y*s,v.z*s)
   return type(1,0,0)
end func

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
