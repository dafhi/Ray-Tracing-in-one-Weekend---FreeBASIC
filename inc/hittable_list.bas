/' -- "sphere.bas" - 2020 Jan 28 - by dafhi -- '/

#ifndef HITTABLELISTH
#define HITTABLELISTH

#include "hittable.bas"

type hittable_list extends hittable
    decl csr( as hittable ptr ptr, int)
    
    declare func _
      hit( as ray, as float, as float, byref as hit_record ) bool
    
    as hittable ptr ptr _
      list
    
    int list_size
End Type

csr hittable_list( l as hittable ptr ptr, n int)
  list = l
  list_size = n
end csr

func hittable_list.hit( r as ray, t_min as float, t_max as float, byref rec as hit_record ) bool
  static as hit_record  temp_rec
  
  var hit_anything = false
  var closest_so_far = cdbl(t_max)
  
  for i int = 0 to list_size-1
    if list[i]<>0 then
      if list[i]->hit(r, t_min, closest_so_far, temp_rec) then
        hit_anything = true
        closest_so_far = temp_rec.t
        rec = temp_rec
      EndIf
    endif
  Next
  return hit_anything
end func

#EndIf
' ------- hittable list