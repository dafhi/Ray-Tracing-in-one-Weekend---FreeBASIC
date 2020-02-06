/'  -- New Camera

  Different-looking than Peter Shirley's

'/

#include "camera.bas"

func color( r as ray, world as hittable ptr, depth int ) as vec3
  static as hit_record rec
  static as ray scattered
  const BOUNCE_MAX = 50
  
  '' Modified
  if world->hit( r, EPS, INF, rec ) then
    dim as vec3 attenu = rec.mat_ptr->albedo
    if depth < BOUNCE_MAX andalso rec.mat_ptr->scatter( r, rec, attenu, scattered ) then
      ret attenu*color(scattered, world, depth+1)
    else
      ret attenu
    endif
  EndIf
  ret sky(r)
End Func


sub main
  
   dim as string kstr

   var scale = 2.4
   var   nx = 200 * scale
   var   ny = 100 * scale
   var   ns = 10

   const                 borderless = 8
   screenres nx, ny, 32',, borderless

   var num_objects = 5

   var list = new hittable ptr[num_objects]
   list[0] = new sphere(vec3(0,0,-1), 0.5, new metal(vec3(0.1, 0.2, 0.5), 1))
   list[1] = new sphere(vec3(0,-100.5,-1), 100, new metal(vec3(0.8, 0.8, 0.0), .99))
   list[2] = new sphere(vec3(1,0,-1), 0.5, new metal(vec3(0.8, 0.6, 0.2), .3))
   list[3] = new sphere(vec3(-1,0,-1), 0.5, new dielectric(1.5, vec3(1, 1, 1), .3))
   list[4] = new sphere(vec3(-1,0,-1), -0.45, new dielectric(1.5, vec3(1, 1, 1), .3))
   var world = new hittable_list(list, num_objects)

   var lookfrom = vec3(3,3,2)
   var lookat = vec3(0,0,-1)
   
   var camera = tCamera( lookfrom, 20, nx/ny )
   camera.vup = vec3(0,1,0)
   
   camera.look_at vec3(0,0,-1)
   camera.aperture = 2
   'camera.vfov = 6
   camera.focus_dist = ((camera.looking_from - camera.looking_at).length)

   def check_screenlock(arg_if, which) if (arg_if) then which

   'var initial = 1
   def lock_condition 0
   
   'for z sng = initial to initial + 6.2 step .01
'      camera.look_from vec3(0,0,z)
      check_screenlock( lock_condition, screenlock )
      for j int = ny-1 to 0 step -1
         for i int = 0 to nx-1
            var col = vec3(0,0,0)
            var s = 0: while s<ns
               var u = (i+rnd-.5)/nx
               var v = (j+rnd-.5)/ny
               var r = camera.get_ray(u,v)
               col += color(r, world, 0)
               s += 1
            wend
            show_pixel( col / ns )
         Next
         if j mod 24=0 then kstr=inkey
         if kstr<>"" then exit for
      next j
      check_screenlock( lock_condition, screenunlock )
      'if kstr<>"" then exit for
      : sleep 1 '' small rest every N scanlines
   'next

   if kstr=chr(27) then exit sub
   sleep
End Sub

Main