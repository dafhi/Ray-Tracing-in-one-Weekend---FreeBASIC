#ifndef MATERIALH
#define MATERIALH

#include "hittable_list.bas"

type tMaterial extends object
  decl virt func scatter( as ray, byref as hit_record, byref as vec3, byref as ray ) bool
  as vec3 albedo
End Type

virt func tMaterial.scatter( _
  r as ray, _
  byref hr as hit_record, _
  byref atten as vec3, _
  byref scatt as ray ) bool
  
  return false
end func


' ----- materials

function reflect(v as vec3, n as vec3) as vec3
  return v - 2*dot(v,n)*n
End Function

function refract(v as vec3, n as vec3, ni_over_nt as float, byref refracted as vec3) bool
  var uv = v.unit_v
  var dt = dot(uv, n)
  var disc = 1 - ni_over_nt*ni_over_nt*(1-dt*dt)
  if disc > 0 then
    refracted = ni_over_nt*(uv - n*dt) - n*sqr(disc)
    return true
  EndIf
  return false
End Function

function random_in_unit_sphere as vec3
  static as vec3 p
  do
    p.x=rnd-.5: p.y=rnd-.5: p.z=rnd-.5
  Loop until p.squared_length < .5
  return 2*p
End Function


type lambertian extends tMaterial
  decl csr( as vec3)
  decl func scatter( as ray, byref as hit_record, byref as vec3, byref as ray) bool
End Type

csr lambertian( a as vec3 )
  albedo = a
end csr

func lambertian.scatter(r as ray, byref rec as hit_record, byref attenu as vec3, byref scattered as ray) bool
  var target = rec.p + rec.normal + random_in_unit_sphere
  scattered = ray(rec.p, target - rec.p)
  attenu = albedo
  return true
end func


type metal extends tMaterial
  decl csr( as vec3, as float = 0 )
  decl func scatter( as ray, byref as hit_record, byref as vec3, byref as ray) bool
  as float fuzz
End Type

csr metal( a as vec3, _fuzz as float )
  albedo = a:  fuzz = _fuzz
end csr

func metal.scatter(r_in as ray, byref rec as hit_record, byref attenu as vec3, byref scattered as ray) bool
  var reflected = reflect( unit_vector(r_in.direction), rec.normal )
  scattered = ray(rec.p, reflected + fuzz*random_in_unit_sphere)
  attenu = albedo
  return dot(scattered.direction, rec.normal) > 0
end func


type dielectric extends tMaterial
  decl csr( as float = 1.1, as vec3=vec3(.9,.9,.9), as float = 0 )
  decl func scatter( as ray, byref as hit_record, byref as vec3, byref as ray) bool
  
  as float ref_idx
  as float fuzz
End Type

csr dielectric( r_i as float, a as vec3, fuz as float)
  albedo = a:  fuzz = fuz:  ref_idx = r_i
end csr

func dielectric.scatter(r_in as ray, byref rec as hit_record, byref attenu as vec3, byref scattered as ray) bool
  static as vec3 outward_normal, refracted
  static as float ni_over_nt
  var reflected = reflect(r_in.direction, rec.normal)
  attenu = albedo
  
  if dot(r_in.direction, rec.normal) > 0 then
    outward_normal = -rec.normal
    ni_over_nt = ref_idx
  else
    outward_normal = rec.normal
    ni_over_nt = 1 / ref_idx
  endif
  
  if refract(r_in.direction, outward_normal, ni_over_nt, refracted) then
    scattered = ray(rec.p, refracted)
  else
    scattered = ray(rec.p, reflected)
    return false
  EndIf
  return true
end func

#endif
' -------- material