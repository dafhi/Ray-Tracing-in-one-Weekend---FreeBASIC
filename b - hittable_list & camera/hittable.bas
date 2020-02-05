#ifndef HITTABLEH
#define HITTABLEH

#include "../inc/ray.bas"

type hit_record
  as float  t
  as vec3   p
  as vec3   normal
End Type

type hittable extends object
  decl csr
  decl virt func hit( as ray, as float, as float, byref as hit_record ) bool
End Type

csr hittable
end csr

virt func hittable.hit( r as ray, r_min as float, t_max as float, byref rec as hit_record ) bool
  return false
end func

#Endif
' ------- hittable