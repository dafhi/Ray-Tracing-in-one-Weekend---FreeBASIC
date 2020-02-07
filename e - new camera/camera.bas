/' -- camera.bas - 2020 Feb 3 - by dafhi

'/

#ifndef CAMERAH
#define CAMERAH

#include "../inc/sphere.bas"

type tBasicCamera
   decl property  vfov( as float )
   decl property  aspect( as float )
   decl sub       look_from( as vec3 )
   decl func      get_ray(as float, as float) as ray
   
 protected:
   decl sub finalize( look_at as vec3, vup as vec3 )
   
   as vec3 origin
   as vec3 lower_left_corner
   as vec3 horizontal
   as vec3 vertical
   
   as float _vfov
   as float _aspect
   
   as vec3  _vup     = vec3(0,1,0)
   as vec3  _look_at = vec3(0,0,-1)
end type

property tBasicCamera.aspect( in as float )
   _aspect = in
   finalize _look_at, _vup
end property
property tBasicCamera.vfov( in as float )
   _vfov = in
   finalize _look_at, _vup
end property
sub tBasicCamera.look_from( ori as vec3 )
   origin = ori
   finalize _look_at, _vup
end sub
func tBasicCamera.get_ray( s as float, t as float ) as ray
   return ray( origin, _
    lower_left_corner + s*horizontal + t*vertical - origin )
end func
sub tBasicCamera.finalize( look_at as vec3, vup as vec3 )
   var theta = _vfov * tau / 360
   var half_height = tan(theta/2)
   var half_width = _aspect * half_height
   var w = unit_vector(origin - look_at)
   var u = unit_vector(cross(vup, w))
   var v = cross(w, u)
   lower_left_corner = origin - half_width*u - half_height*v - w
   horizontal = 2*half_width*u
   vertical = 2*half_height*v
end sub


''
type tCamera extends tBasicCamera
   decl csr( as vec3 = vec3(0,0,0), as float = 90, as float = 4/3 )
   decl sub look_at( as vec3 )
   decl sub move( as vec3 )
   decl property vup( as vec3 )
End Type

csr tCamera( lookfrom as vec3, __vfov as float, __aspect as float) '' vfov is top to bottom in degrees
   _vfov = __vfov
   _aspect = __aspect
   look_from lookfrom
end csr

sub tCamera.look_at( in as vec3 )
   finalize in, _vup
end sub

sub tCamera.move( amount as vec3 )
   look_from origin + amount
end sub

property tCamera.vup( in as vec3 )
   finalize _look_at, in
end property

#Endif
' ------- camera