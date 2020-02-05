/' -- ray.bas (FreeBASIC) - 2020 Jan 28 - by dafhi
  from the book "Ray Tracing In One Weekend" by Peter Shirley
'/

#ifndef RAYH
#define RAYH

#include "vec3.bas"

type ray
  decl  csr
  decl  csr( as vec3, as vec3 )
  decl  func point_at_parameter( as float) as vec3
  
  as vec3 origin, direction
End Type

csr ray
end csr

csr ray( a as vec3, b as vec3 )
  origin=a: direction=b
end csr

func ray.point_at_parameter(t as float) as vec3
  ret origin + t*direction
end func

function sky( r as ray ) as vec3
  var unit_direction = r.direction.unit_v
  var t = .5*(unit_direction.y + 1)
  return (1-t)*vec3(1,1,1) + t*vec3(.5,.7,1)
End Function

#endif
' ------ ray