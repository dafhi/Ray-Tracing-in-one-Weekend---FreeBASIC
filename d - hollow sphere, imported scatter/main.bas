/'
  Different looking from Peter Shirley's hollow glass sphere :\

  Imported my 2016 path tracer scatter func (improved by Shirley's random_in_unit_sphere)
'/

#include "camera.bas"

function color( r as ray, world as hittable ptr, depth int ) as vec3
  static as hit_record rec
  static as ray scattered
  if world->hit(r, EPS, INF, rec) then
    dim as vec3 attenuation
    if depth < 50 andalso rec.mat_ptr->scatter(r, rec, attenuation, scattered) then
      return attenuation*color(scattered, world, depth+1)
    else
      return vec3(0,0,0)
    endif
  EndIf
  return sky(r)
End Function


sub main
  
  dim as string kstr
  
  var scale = 2.4
  var   nx = 200 * scale
  var   ny = 100 * scale
  var   ns = 17
  
  const                 borderless = 8
  screenres nx, ny, 32',, borderless
 
  var num_objects = 5
  
  var list = new hittable ptr[num_objects]
  list[0] = new sphere(vec3(0,0,-1), 0.5, new metal(vec3(0.8, 0.3, 0.3), 1))
  list[1] = new sphere(vec3(0,-100.5,-1), 100, new metal(vec3(0.8, 0.8, 0.0), .99))
  list[2] = new sphere(vec3(1,0,-1), 0.5, new metal(vec3(0.8, 0.6, 0.2), .3))
  list[3] = new sphere(vec3(-1,0,-1), 0.5, new dielectric(1.5, vec3(1, 1, 1), .3))
  list[4] = new sphere(vec3(-1,0,-1), -0.45, new dielectric(1.5, vec3(1, 1, 1), .3))
  
  var world = new hittable_list(list, num_objects)
  var camera = tCamera
  var r = camera.get_ray(.3, .5)
  var k = color(r, world, 0)
  
  for j int = ny-1 to 0 step -1
    for i int = 0 to nx-1
      var col = vec3(0,0,0)
      var s = 0: while s<ns
        var u = (i+rnd-.5)/nx
        var v = (j+rnd-.5)/ny
        var r = camera.get_ray(u,v)
        r.direction.make_unit_vector
        col += color(r, world, 0)
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