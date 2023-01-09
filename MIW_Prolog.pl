room(corridor).
room(hall).
room(bathroom).
room(bedroom).
room(kitchen).
room(livingroom).
room(balcony).

 

object(elevator).
object(bed).
object(wardrobe).
object(bath).
object(toilet).
object(storage).
object(fridge).
object(microwave).
object(tv).
object(couch).
object(bench).

 

is_in_room(elevator, corridor).
is_in_room(bed, bedroom).
is_in_room(wardrobe, bedroom).
is_in_room(bath, bathroom).
is_in_room(toilet, bathroom).
is_in_room(storage, hall).
is_in_room(fridge, kitchen).
is_in_room(microwave, kitchen).
is_in_room(tv, livingroom).
is_in_room(couch, livingroom).
is_in_room(bench, balcony).