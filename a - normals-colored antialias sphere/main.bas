/' -- anti-aliased colored-by-surface-normals sphere -- '/

#include "../inc/ray.bas"

function hit_sphere( center as vec3, radius as float, r as ray ) as float
  var oc = r.origin - center
  var a = dot(r.direction, r.direction)
  var b = 2 * dot(oc, r.direction)
  var c = dot(oc, oc) - radius * radius
  var disc = b*b - 4*a*c
  return iif( disc<0, -1, (-b - sqr(disc)) / (2*a) )
End Function

function color( r as ray ) as vec3
  var t = hit_sphere( vec3(0,0,-1), .5, r)
  if t>0 then
    var n = unit_vector(r.point_at_parameter(t) - vec3(0,0,-1))
    ret .5*vec3(n.x+1,n.y+1,n.z+1)
  EndIf
  return sky(r)
End Function


sub main
  
  dim as string kstr
  
  var scale = 2.4
  var   nx = 200 * scale
  var   ny = 100 * scale
  var   ns = 7
  
  const                 borderless = 8
  screenres nx, ny, 32,, borderless
 
  var lower_left_corner = vec3(-2,-1,-1)
  var horizontal = vec3(4,0,0)
  var vertical = vec3(0,2,0)
  var origin = vec3(0,0,0)
 
  for j int = ny - 1 to 0 step -1
    
    var i = 0: while i<nx
      var col = vec3(0,0,0)
      var s = 0: while s<ns
        var u = (i+rnd-.5)/nx
        var v = (j+rnd-.5)/ny
        var r = ray(origin, lower_left_corner + u*horizontal + v*vertical)
        col += color(r)
        s += 1
      wend
      show_pixel( col / ns )
      i += 1
    wend
    
    if j mod 24=0 then kstr=inkey: sleep 1 '' small rest every N scans
    if kstr<>"" then exit for
  next j
  
  if kstr=chr(27) then exit sub
  sleep
End Sub

Main