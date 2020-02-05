/' -- "sphere.bas" - 2020 Jan 28 - by dafhi -- '/

#ifndef SPHEREH
#define SPHEREH

type sphere extends hittable
    
    decl   csr(as vec3, as float, as tMaterial ptr)
    
    declare func hit( as ray, as float, as float, byref as hit_record ) bool
    
    as vec3   center
    
    decl prop radius(as float) '' updates rad and r2
    decl prop radius as float  '' returns rad
    
    as float  rad              '' read only ;)
    as float  r2
    as float  irad
    as tMaterial ptr _
      mat_ptr
End Type

csr sphere(cen as vec3, r as float, mat as tMaterial ptr)
  center = cen: radius = r: mat_ptr = mat
end csr

func sphere.hit( r as ray, t_min as float, t_max as float, byref rec as hit_record  ) bool
  static as float b, c, a
  static as float t1, t2
  static as float sqr_disc, disc
  
  var oc = r.origin - center
  r.direction.make_unit_vector

  'a = dot(r.direction, r.direction) '' dot
  b = dot(oc, r.direction)
  c = dot(oc, oc) - r2

  disc = b*b - c'*a
  if disc <= 0 then return 0
  
  sqr_disc = sqr(disc)

  t2 = (-b + sqr_disc) '/ a
  if t2 < EPS then return 0
  
  t1 = (-b - sqr_disc) '/ a
  if t1 >= t_max then  return 0

  #macro sphere_was_hit(_t)
    rec.t = _t
    rec.p = r.point_at_parameter(rec.t)
    rec.normal = (rec.p - center).unit_v
    rec.mat_ptr = mat_ptr
    return True
  #EndMacro
   
  if t1 >= EPS then
    sphere_was_hit( t1 )
  EndIf
  
  if t2 < t_max then
    sphere_was_hit( t2 )
  endif

  return 0

end func

prop sphere.radius(in as float)
  rad = in: r2 = in*in: irad = 1/in
end prop

prop sphere.radius as float
  return rad
end prop

#EndIf
' ------- sphere