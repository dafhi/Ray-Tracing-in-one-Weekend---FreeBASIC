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

function schlick(cosine as float, ref_idx as float) as float
  var r0 = (1-ref_idx)/(1+ref_idx)
  r0 = r0*r0:  return r0 + (1-r0)*(1-cosine)^5
End Function

function random_in_unit_sphere as vec3
  static as vec3 p
  do
    p=vec3(rnd-.5,rnd-.5,rnd-.5)
  Loop until p.squared_length < .5
  return 2*p
End Function

'' my scattering function
function norm_scatter( byval ray_d as vec3, surf_n as vec3, k as float ) as vec3
  static as single  arc_from_norm, arc, cosa
  static as vec3      vtemp, plane_cos, plane_sin
  
  '' angle between -ray and normal
  ray_d = -ray_d.unit_v
  cosa = dot(ray_d, surf_n)
  arc_from_norm = acos(cosa)
 
  '' perps to construct refl norm average
  plane_cos = surf_n * cos(arc_from_norm)
  plane_sin = ray_d - plane_cos
    
  '' The average.  [k = 1] will point at (-ray + norm) / 2
  arc = arc_from_norm * k / 2
  vtemp = cos(arc) * surf_n + sin(arc) * plane_sin.unit_v
  
  const sphere_distance = sqr(2)
  
  return vtemp * sphere_distance + random_in_unit_sphere * k
End Function


''
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


''
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
  scattered = ray( rec.p, norm_scatter(r_in.direction, reflected, fuzz))
  attenu = albedo
  return dot(scattered.direction, rec.normal) > 0
end func


''
type dielectric extends tMaterial
  decl csr( as float = 1.1, as vec3=vec3(1,1,1), as float = 0 )
  decl func scatter( as ray, byref as hit_record, byref as vec3, byref as ray) bool
  
  as float ref_idx
  as float fuzz
End Type

csr dielectric( r_i as float, a as vec3, fuz as float)
  albedo = a:  fuzz = fuz:  ref_idx = r_i
end csr

func dielectric.scatter(r_in as ray, byref rec as hit_record, byref attenu as vec3, byref scattered as ray) bool
  static as float reflect_prob
  static as float cosine
  
  
  'var reflected = reflect(r_in.direction, rec.normal)
  attenu = albedo
  
  #if 0
    
    '' experimental
    
    #define chance_of_tir _
      cosine < 0 xor ref_idx > 1
    
    cosine = dot(r_in.direction.unit_v, rec.normal)
    
    if chance_of_tir then
      
      if refract(r_in.direction, rec.normal, ref_idx, scattered.direction) then
        reflect_prob = schlick(cosine, ref_idx)
      else
        reflect_prob = 1
      EndIf
      ' ? " "  '' FreeBASIC print statement
    else
      if refract(r_in.direction, rec.normal, 1/ref_idx, scattered.direction) then
        reflect_prob = schlick(cosine/r_in.direction.length, ref_idx)
      else
        reflect_prob = 1
      endif
      ' ? " "
    endif
  
      scattered = ray(rec.p, reflect( r_in.direction, rec.normal ))
  
  #else '' Shirley's version
    static as vec3 outward_normal
    static as vec3 refracted, reflected
    static as float ni_over_nt
    
    if dot(r_in.direction, rec.normal) > 0 xor ref_idx < 1 then
      outward_normal = -rec.normal
      ni_over_nt = ref_idx
      '? "inside"
      cosine = ref_idx * dot(r_in.direction, rec.normal) / r_in.direction.length
    else
      '? "outside"
      outward_normal = rec.normal
      ni_over_nt = 1 / ref_idx
      cosine = -dot(r_in.direction, rec.normal) / r_in.direction.length
    endif
    
    if refract(r_in.direction, outward_normal, ni_over_nt, refracted) then
      reflect_prob = schlick(cosine, ref_idx)
    else
      reflect_prob = 1
    EndIf
    
    if rnd < reflect_prob then
      scattered = ray(rec.p, reflected)
    else
      scattered = ray(rec.p, refracted)
    endif
    
  #endif
  return true
end func

#endif
' -------- material