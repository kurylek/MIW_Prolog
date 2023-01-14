% Create dynamic variables
:- dynamic myPosition/1.
:- dynamic itemPosition/2.
:- dynamic hasWardrobeKey/1.
:- dynamic tvState/1.
:- dynamic inventory/2.

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
                  or go back to kitchen. It`s your choice! If u want you can walk near TV! ((`forwardNearTv`)).
                  I said TV? You can turn it ON ((`turnOnTv([channel, volume])`)), OFF ((`turnOffTv`))
                  And change channel and volume ((`changeTv([channel, volume])`))').
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
object(wardrobeKeys).

% Describe where is objcect- isInRoom(object, room)
isInRoom(elevator, corridor).
isInRoom(bed, bedroom).
isInRoom(wardrobe, bedroom).
isInRoom(bath, bathroom).
isInRoom(toilet, bathroom).
isInRoom(storage, hall).
isInRoom(fridge, kitchen).
isInRoom(microwave, kitchen).
isInRoom(tv, livingroom).
isInRoom(couch, livingroom).
isInRoom(bench, balcony).

% Describe that romm contains object containsObject(room, object)
containsObject(X, Y) :- isInRoom(Y, X).

% Describe paths between rooms room(from, to, direction)
getTo(corridor, hall, forward).
getTo(hall, corridor, back).
getTo(hall, bathroom, right).
getTo(bathroom, hall, left).
getTo(hall, bedroom, forward).
getTo(bedroom, hall, back).
getTo(hall, kitchen, left).
getTo(kitchen, hall, right).
getTo(kitchen, livingroom, forward).
getTo(livingroom, kitchen, back).
getTo(livingroom, balcony, forward).
getTo(balcony, livingroom, back).

% Take sth from fridge
move(fridgeTake(X)) :-
    (myPosition(kitchen) ->  
    	(inventory(fridge, X) ->
    		retract(inventory(fridge, X)),
    		assert(inventory(pocket, X)),
        	write('Lets take '),
        	write(X),
        	writeln(' from fridge, so I can eat it!')
    		;write('Hm.. I there is no '),
        	write(X),
        	writeln(' in fridge!')
    	);notThere(fridge)
    ).

% Store sth in fridge
move(fridgePut(X)) :-
    (myPosition(kitchen) ->  
    	(inventory(pocket, X) ->
    		retract(inventory(pocket, X)),
    		assert(inventory(fridge, X)),
        	write('Lets put '),
        	write(X),
        	writeln(' to fridge, so I can eat it later!')
    		;write('Hm.. I dont have '),
        	write(X),
        	writeln(' in my pockets!')
    	);notThere(fridge)
    ).

% Checking pockets
move(checkPockets) :-
    (inventory(pocket, _) ->
    	write('I`m checking my pockets.. I have: '),
    	listInventory(pocket),
    	writeln('If u want to eat it just say me ((`eat(X)`)), or you can store it in fridge!')
    	;writeln('Oh.. It looks like my pockets are empty.. Not good, not good..')
    ).

% Checking fridge
move(checkFridge) :-
    (myPosition(kitchen) ->  
    	(inventory(fridge, _) ->
    		write('I`m checking fridge.. There is: '),
    		listInventory(fridge)
    		;writeln('Oh.. It looks like my fridge is empty.. It`s time to go shoping!')
    	);notThere(fridge)
    ).

% Eat sth from pocket
move(eat(X)) :-
    (inventory(pocket, X) ->
    	retract(inventory(pocket, X)),
        write('Omnomno.. I just ate '),
        write(X),
        writeln('!')
    	;write('Hm.. I dont have '),
        write(X),
        writeln(' in my pockets!')
    ).

% Move forward near TV
move(forwardNearTv) :-
    (myPosition(livingroom) -> 
        writeln('You walk forward near TV'),
        move(forward)
    	;notThere(tv)
    ).

% Turn ON TV and set up channel and volume
move(turnOnTv(ChannelVolume)) :-
    (myPosition(livingroom) -> 
    	(tvState(off) ->  
    		writeln('Turning TV ON..'),
    		retract(tvState(off)),
    		assert(tvState(on)),
    		move(changeTv(ChannelVolume))
        	;writeln('TV is already turned ON!')
        )
    	;notThere(tv)
    ).

% set up channel and volume
move(changeTv([X, Y])) :-
    (myPosition(livingroom) -> 
    	(tvState(on) ->
    		write('Swapped to channel '),
    		write(X),
    		write(' changed volume to '),
    		write(Y)
        	;writeln('TV is turned Off!')
        )
    	;notThere(tv)
    ).

% Turn OFF TV
move(turnOffTv) :-
    (myPosition(livingroom) -> 
    	(tvState(on) ->
    		writeln('Turning TV OFF..'),
    		retract(tvState(on)),
    		assert(tvState(off))
        	;writeln('TV is already turned Off!')
        )
    	;notThere(tv)
    ).

% Do something with bed
move(bed) :-
    myPosition(Position),
    (isInRoom(bed, Position) -> bed(Position) ; notThere(bed)).

% Do something with couch
move(couch) :-
    myPosition(Position),
	(isInRoom(couch, Position) -> couch(Position) ; notThere(couch)).

% Do something with wardrobe
move(wardrobe) :-
    myPosition(Position),
	(isInRoom(wardrobe, Position) -> wardrobe(Position) ; notThere(wardrobe)).

%  Go to elevator
move(elevator) :-
    myPosition(Position),
	(isInRoom(elevator, Position) -> elevator(Position) ; notThere(elevator)).

% Go to given direction
move(Direction) :- % goes in specific direction
    myPosition(Position),
    getTo(Position, To, Direction),
    retract(myPosition(Position)),
    assert(myPosition(To)),
    write('You go to '), write(Direction),
    write(' and enter '), writeln(To),
    lookAround,
    !.  

% Called when u can't go to given direction/typed something that you can't do
move(_) :-
    writeln('You can`t go there, or you are trying to do something stupid!'),
    lookAround.


% Called when you want to do something with bed
bed(Position) :-
    myPosition(Position),
	isInRoom(bed, Position),
    % Picking/Leaving keys 
    (itemPosition(wardrobeKeys, bed)->  
    	writeln('How can I take a nap, when there is something.. Oh!! Thats my wardrobekeys!'),
    	retractall(hasWardrobeKey(_)),
    	assertz(hasWardrobeKey(yes)),
    	retract(itemPosition(wardrobeKeys, bed)),
		assert(itemPosition(wardrobeKeys, pockets))
    	;writeln('I love.. Naps..'),
        takeNap(5),
        (hasWardrobeKey(yes) ->  
    		retractall(hasWardrobeKey(_)),
    		assertz(hasWardrobeKey(no)),
    		retract(itemPosition(wardrobeKeys, pockets)),
			assert(itemPosition(wardrobeKeys, bed))
        	;writeln('It look`s like there was something.. But what was that?')
        )
    ),
    !.

% Called when you want to do something with couch
couch(Position) :-
    myPosition(Position),
	isInRoom(couch, Position),
    % Picking/Leaving keys 
    (hasWardrobeKey(no), itemPosition(wardrobeKeys, couch)->  
    	writeln('Ough! I sat on someting! [..] Ohh! These keys are from the wardrobe! I thought I threw them away..'),
    	retractall(hasWardrobeKey(_)),
    	assertz(hasWardrobeKey(yes)),
    	retract(itemPosition(wardrobeKeys, couch)),
		assert(itemPosition(wardrobeKeys, pockets))
    	;writeln('That couch.. Kind of old, but still very comfortable..'),
        (hasWardrobeKey(yes) ->  
    		retractall(hasWardrobeKey(_)),
    		assertz(hasWardrobeKey(no)),
    		retract(itemPosition(wardrobeKeys, pockets)),
			assert(itemPosition(wardrobeKeys, couch))
        	;writeln('It look`s like there was something.. But what was that?')
        )
    ),
    !.

% Called when you want to do something with wardrobe
wardrobe(Position) :-
    myPosition(Position),
	isInRoom(wardrobe, Position),
    (hasWardrobeKey(no) ->  
    	writeln('Oh.. It`s closed! I don`t remember where the keys are. I think I threw them away.')
    	;writeln('Oh.. It`s closed! But.. I have keys! [..] Well.. Why did I locked empty wardrobe?')
    ),
    !.

% Called when you go inside elevator
elevator(Position) :-
    myPosition(Position),
	isInRoom(elevator, Position),
    writeln('Okey, let`s go out!'),
    retract(myPosition(Position)),
    assert(myPosition(out)),
    !.

% Called when you want to interact with object that is not in your room
notThere(Move) :-
    write('Are you blind? There is no '),
    write(Move),
    writeln(' in here!'),
    !.
 
% Starting nap
takeNap(X):-
    snore(1,X).

% Taking nap- recursion
snore(Y1,X):-
    (Y1=<X -> 
        write('Zzz..'),
        Y2 is Y1+1,
        snore(Y2,X)
    ;   writeln('Ouh.. That was good nap!')).

% List inventory
listInventory(X) :-
    forall(inventory(X, Y), (write(Y), write(', '))),
    nl.

% Describe current room
lookAround :-
    myPosition(Position),
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
    writeln('In livingroom you can interact with TV'),
    writeln('Hungry? You can eat something with `eat(X)`, if not better put it to fridge! '),
    writeln('---'),
    writeln('Good luck!'),
	nl.

% Check if went to elevator
moveHandler :-
    myPosition(out),
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
    assert(myPosition(corridor)),
	assert(hasWardrobeKey(no)),
    assert(tvState(off)),
	assert(itemPosition(wardrobeKeys, couch)),
	assert(inventory(pocket, bannana)),
	assert(inventory(pocket, apple)),
	assert(inventory(fridge, grapes)).
    

% Starting game
start :-
    moves,
    writeln('You have left the elevator and are in the corridor.'),
    setup,
    lookAround,
    moveHandler.