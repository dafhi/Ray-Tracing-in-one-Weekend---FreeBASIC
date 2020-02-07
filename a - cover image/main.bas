/'  -- Cover image
'/

#include "../inc/camera.bas"

func random_scene as hittable ptr
  var n = 500
  dim as hittable ptr ptr list = new hittable ptr[n+1]
  list[0] = new sphere(vec3(0,-1000,0), 1000, new lambertian(vec3(.5,.5,.5)))
  
  list[1] = new sphere( vec3(0,1,0), 1, new dielectric( 1.5 ) )
  list[2] = new sphere( vec3(-4,1,0),1, new lambertian( vec3(.4,.2,.1) ) )
  list[3] = new sphere( vec3(4,1,0), 1, new metal( vec3(.7,.6,.5), 0 ) )
  
  var i = 4
  for a int = -10 to 10
    for b int = -10 to 10
      var choose_mat = rnd
      var center = vec3(a+.9*rnd,.2,b+.9*rnd)
      if (center-vec3(4,.2,0)).length > .9 then
        if choose_mat < .8 then
          
          list[i] = new sphere( _
            center, .2, new dielectric( _
              1.5, vec3(1-rnd*rnd,1-rnd*rnd,1-rnd*rnd), rnd*rnd*rnd))
        elseif choose_mat < .95 then
          
          list[i] = new sphere( _
            center, .2, new metal(.5*vec3(1+rnd,1+rnd,1+rnd),.5*rnd))
        else
          
          list[i] = new sphere( _
            center, .2, new lambertian(vec3(rnd*rnd,rnd*rnd,rnd*rnd)))
        endif
        i += 1
      EndIf
    Next
  Next
  return new hittable_list(list,i)
end func

func color( r as ray, world as hittable ptr, depth int ) as vec3
  static as hit_record rec
  static as ray scattered:  const BOUNCE_MAX = 50
  
  ' Modified
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

   var scale = .5
   var   nx = 1200 * scale
   var   ny = 800 * scale
   var   ns = 5

   const                 borderless = 8
   screenres nx, ny, 32',, borderless

   var world = random_scene

   var lookat = vec3(0,0,0)
   
   var camera = tCamera( vec3(13,2,3)*1, 20, nx/ny )

   camera.aperture = .1
   camera.focus_dist = 10
   camera.look_at vec3(0,0,0)

   def check_screenlock(arg_if, which) if (arg_if) then which

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
      if j mod 12=0 then kstr=inkey: sleep 1 '' small rest every N scanlines
      if kstr<>"" then exit for
   next j

   if kstr=chr(27) then exit sub
   sleep
End Sub

Main