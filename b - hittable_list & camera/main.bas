/' -- anti-aliased colored-by-surface-normals sphere w/ green ground --

  "hittable list"

'/

#include "sphere.bas"

function color( r as ray, world as hittable ptr ) as vec3
  static as hit_record rec
  if world->hit(r, 0.0, INF, rec) then
    return .5*vec3(rec.normal.x+1, rec.normal.y+1, rec.normal.z+1)
  EndIf
  return sky(r)
End Function

sub main
  
  dim as string kstr
  
  var scale = 2.4
  var   nx = 200 * scale
  var   ny = 100 * scale
  var   ns = 6
  
  const                 borderless = 8
  screenres nx, ny, 32,, borderless
 
  var lower_left_corner = vec3(-2,-1,-1)
  var horizontal = vec3(4,0,0)
  var vertical = vec3(0,2,0)
  var origin = vec3(0,0,0)
 
  var num_objects = 2
  
  var list = new hittable ptr[num_objects]
  list[0] = new sphere(vec3(0,0,-1), .5)
  list[1] = new sphere(vec3(0,-100.5,-1), 100)
  var world = new hittable_list(list, num_objects)
 
  for j int = ny-1 to 0 step -1
    for i int = 0 to nx-1
      var col = vec3(0,0,0)
      var s = 0: while s<ns
        var u = (i+rnd-.5)/nx
        var v = (j+rnd-.5)/ny
        var r = ray(origin, lower_left_corner + u*horizontal + v*vertical)
        col += color(r, world)
        s += 1
      wend
      show_pixel( col / ns )
    Next
    
    if j mod 24=0 then kstr=inkey: sleep 1 '' small rest every N scanlines
    if kstr<>"" then exit for
  next j
  
  if kstr=chr(27) then exit sub
  sleep
End Sub

Main