/' -- camera.bas - 2020 Feb 3 - by dafhi

  Shirley's base class converted to an animation-ready format

'/

#ifndef CAMERAH
#define CAMERAH

#include "../inc/sphere.bas"

func random_in_unit_disk as vec3
   static as vec3 p
   do
      p.x = rnd-.5: p.y = rnd-.5
   loop until p.x*p.x + p.y*p.y < .5
   return 2*p
end func

type tBasicCamera
   decl prop  vfov( as float )
   decl prop  aspect( as float )
   decl sub   look_from( as vec3 )
   decl func  get_ray(as float, as float) as ray
   
 protected:
   decl sub finalize( look_at as vec3, vup as vec3 )
   
   as vec3  origin
   as vec3  lower_left_corner
   as vec3  horizontal
   as vec3  vertical
   as vec3  u, v, w
   as float lens_radius
   
   as float _vfov
   as float _aspect
   
   as vec3  _vup     = vec3(0,1,0)
   as vec3  _look_at = vec3(0,0,-1)
   as float _aperture = 1
   as float _focus_dist = 1.5
end type

sub tBasicCamera.finalize( look_at as vec3, vup as vec3 )
   lens_radius = _aperture / 2
   var theta = _vfov * tau / 360
   var half_height = tan(theta/2) * _focus_dist
   var half_width = _aspect * half_height
   w = unit_vector(origin - look_at)
   u = unit_vector(cross(vup, w))
   v = cross(w, u)
   lower_left_corner = origin - half_width*u - half_height*v - w* _focus_dist
   horizontal = 2*half_width*u
   vertical = 2*half_height*v
   _look_at = look_at
   _vup = vup
end sub

prop tBasicCamera.aspect( in as float )
   _aspect = in
   finalize _look_at, _vup
end prop
prop tBasicCamera.vfov( in as float )
   _vfov = in
   finalize _look_at, _vup
end prop
sub tBasicCamera.look_from( ori as vec3 )
   origin = ori
   finalize _look_at, _vup
end sub

func tBasicCamera.get_ray( s as float, t as float ) as ray
   static as vec3 rd, _offset
   
   rd = lens_radius * random_in_unit_disk
   _offset = u*rd.x + v*rd.y
   
   return ray( _
      origin + _offset, _
      lower_left_corner + s*horizontal + t*vertical - origin - _offset)
end func


'' Main camera class
type tCamera extends tBasicCamera
   decl csr( as vec3 = vec3(0,0,0), as float = 90, as float = 4/3 )
   decl sub    look_at( as vec3 )
   decl sub    move( as vec3 )
   decl sub    vup( as vec3 )
   decl prop   aperture( as float )
   decl prop   focus_dist( as float )
   decl prop   looking_from as vec3
   decl prop   looking_at as vec3
End Type

csr tCamera( lookfrom as vec3, __vfov as float, __aspect as float) '' vfov is top to bottom in degrees
   _vfov = __vfov
   _aspect = __aspect
   look_from lookfrom
end csr

prop tCamera.looking_from as v3
   ret origin
end prop

prop tCamera.looking_at as v3
   ret _look_at
end prop

prop tCamera.aperture( in as float )
   _aperture = in
   finalize _look_at, _vup
end prop

prop tCamera.focus_dist( in as float )
   _focus_dist = in
   finalize _look_at, _vup
end prop

sub tCamera.look_at( in as vec3 )
   finalize in, _vup
end sub

sub tCamera.move( amount as vec3 )
   look_from origin + amount
end sub

sub tCamera.vup( in as vec3 )
   finalize _look_at, in
end sub

#Endif
' ------- camera