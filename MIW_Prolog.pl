% Create dynamic variables
:- dynamic position/2.
:- dynamic hasWardrobeKey/1.

% Create rooms- room(roomName, Description)
room(corridor, 'Corridor again.. Ugh.. Let`s enter apartment.. The door is in front of you!').
room(hall, 'All roads lead to Ro.. Hall of course! I think there sould be something in storage.
            Or maybe.. Let`s move! Bathroom should be on right, kitchen on left..
            Bedroom in front and to go out turn around to corridor behind you!').
room(bathroom, 'Thank God it`s clean right here! I think it`s not time to take a bath or to use wc!
                Let`s go back to hall- it`s on left!').
room(bedroom, 'Look at this bed! It`s so huge.. How about a quick nap? [..] No?
               So let`s check this big wardrobe or let`s go back to hall- it`s behind you!').
room(kitchen, 'Wow.. I wish I know how to cook, that microwave was worth it`s price..
               You can go to living room it`s ahead, or to hall on right.').
room(livingroom, 'Living room without TV would be deadroom! You can go out to the balcony- it`s in front,
                  or go back to kitchen. It`s your choice!').
room(balcony, 'Maybe is small, but hey! It`s yours! Take a look around, or go back inside.').

% Create objects- object(objectname)
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

% Describe where is objcect- is_in_room(object, room)
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

% Describe paths between rooms room(from, to, direction)
get_to(corridor, hall, forward).
get_to(hall, corridor, back).
get_to(hall, bathroom, right).
get_to(bathroom, hall, left).
get_to(hall, bedroom, forward).
get_to(bedroom, hall, back).
get_to(hall, kitchen, left).
get_to(kitchen, hall, right).
get_to(kitchen, livingroom, forward).
get_to(livingroom, kitchen, back).
get_to(livingroom, balcony, forward).
get_to(balcony, livingroom, back).


% Do something with wardrobe
move(wardrobe) :-
    position(you, Position),
    wardrobe(Position).

%  Go to elevator
move(elevator) :-
    position(you, Position),
    elevator(Position).

% Go to given direction
move(Direction) :- % goes in specific direction
    position(you, Position),
    get_to(Position, To, Direction),
    retract(position(you, Position)),
    assert(position(you, To)),
    write('You go to '), write(Direction),
    write(' and enter '), writeln(To),
    lookAround,
    !.  

% Called when u can't go to given direction/typed something that you can't do
move(_) :-
    writeln('You can`t go there, or you are trying to do something stupid!'),
    lookAround.


% Called when you want to do something with wardrobe
wardrobe(Position) :-
    position(you, Position),
	is_in_room(wardrobe, Position),
    (hasWardrobeKey(no) ->  
    writeln('Oh.. It`s closed! I don`t remember where the keys are. I think I threw them away.')
    ;writeln('Oh.. It`s closed! But.. I have keys! [..] Well.. Why did I locked empty wardrobe?')
    ),
    !.

% Called when u cant do anything with wardrobe
wardrobe(_) :-
    writeln('Wardrobe? What wardrobe? There is no wardrobe right here! I think, that it should be in bedroom!'),
    !.

% Called when you go inside elevator
elevator(Position) :-
    position(you, Position),
	is_in_room(elevator, Position),
    writeln('Okey, let`s go out!'),
    retract(position(you, Position)),
    assert(position(you, out)),
    !.

% Called when there is no elevator in room
elevator(_) :-
    writeln('Are you blind? There is no elevator in here!'),
    !.


% Describe current room
lookAround :-
    position(you, Position),
    room(Position, RoomDescription),
    writeln(RoomDescription).

% Print how to move
moves :-
    writeln('Hey! To move you have to type some body relative direction!'),
	writeln('So you have four moving options- left, right, foward and back!'),
    writeln('---'),
	writeln('There are some interactions with objects too!'),
	writeln('To go out type `elevator`'),
	writeln('To check what is in wardrobe type `wardrobe`'),
    writeln('---'),
    writeln('Good luck!'),
	nl.

moveHandler :- % end of main loop
    position(you, out),
    writeln('You entered elevator and then leaved building!'),
    !.
% Loop with player moves
moveHandler :-
    nl,
    writeln('What do you want to do?'),
    read(Move),
    call(move(Move)),
    moveHandler.

% Setup game
setup :-
    retractall(position(_,_)),
    assert(position(you, corridor)),
	assert(hasWardrobeKey(no)),
	%retractall(hasWardrobeKey(_)),
	%assertz(hasWardrobeKey(yes)).

% Starting game
start :-
    moves,
    writeln('You have left the elevator and are in the corridor.'),
    setup,
    lookAround,
    moveHandler.