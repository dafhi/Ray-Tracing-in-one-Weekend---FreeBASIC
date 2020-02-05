/'  -- New Camera

  Different-looking than Peter Shirley's

'/

#include "camera.bas"

func color( r as ray, world as hittable ptr, depth int ) as vec3
  static as hit_record rec
  static as ray scattered
  const BOUNCE_MAX = 0
  
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
   var   ns = 1

   const                 borderless = 8
   screenres nx, ny, 32',, borderless

   var num_objects = 2

   var list = new hittable ptr[num_objects]

   dim as float r = cos(piBy4)
   list[0] = new sphere(vec3(-r,0,-1), R, new lambertian(vec3(0,0,1)))
   list[1] = new sphere(vec3( r,0,-1), R, new lambertian(vec3(1,0,0)))
   var world = new hittable_list(list, num_objects)

   var camera = tCamera( vec3(-2,2,1), 90, nx/ny )
   camera.look_at vec3(0,0,-1)
   camera.vup = vec3(0,1,0)

   def check_screenlock(arg_if, which) if (arg_if) then which

   'var initial = 1
   def nolock_condition 1
   
   'for z sng = initial to initial + 6.2 step .01
'      camera.look_from vec3(0,0,z)
      check_screenlock( nolock_condition, screenlock )
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
      check_screenlock( nolock_condition, screenunlock )
      'if kstr<>"" then exit for
      : sleep 1 '' small rest every N scanlines
   'next

   if kstr=chr(27) then exit sub
   sleep
End Sub

Main