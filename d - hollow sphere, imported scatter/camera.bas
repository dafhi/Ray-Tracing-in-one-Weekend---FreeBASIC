/' -- camera.bas - 2020 Feb 3 - by dafhi

  #include for material also here
  
  (at the end)

'/


#ifndef CAMERAH
#define CAMERAH

#include "../inc/sphere.bas"

type tCamera
  decl csr
  decl func get_ray(as float, as float) as ray
  
  as vec3 origin
  as vec3 lower_left_corner
  as vec3 horizontal
  as vec3 vertical
End Type

csr tCamera
  lower_left_corner = vec3(-2, -1, -1)
  horizontal = vec3(4, 0,0)
  vertical = vec3(0, 2,0)
  origin = vec3(0, 0,0)
end csr

func tCamera.get_ray( u as float, v as float ) as ray
  return ray( origin, _
    lower_left_corner + u*horizontal + v*vertical - origin )
end func

#Endif
' ------- camera