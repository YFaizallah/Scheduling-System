% Scheduling System Prolog Project:  

%a
week_schedule([],_,_,[]).
week_schedule([DaySched|T], TAS, DayMax, [Assignment|Xs]) :- day_schedule(DaySched, TAS, REM, Assignment),
    max_slots_per_day(Assignment,DayMax ),week_schedule(T, REM, DayMax, Xs).

%b
day_schedule([], L, L, []).
day_schedule([H|T], TAs, RemTAs, [Name|Xs]) :- slot_assignment(H,TAs,Rem1,Name),day_schedule(T,Rem1,RemTAs,Xs).

%c
count_occurences([], _, 0).
count_occurences([X|T], X, Y) :- count_occurences(T, X, Y1), Y is 1 + Y1.
count_occurences([X1|T], X, Z) :- X1 \= X, count_occurences(T, X, Z).

count_list(L, CL) :- sort(L, L1), count_list1(L, L1, CL).
count_list1(_, [], []).
count_list1(L, [H|T] , [N|T1]) :- count_occurences(L, H, N), count_list1(L, T, T1). 

max(X, Y, Z) :- (X > Y, Z = X); (Y >= X, Z = Y).
maxInList([X], X).
maxInList([X,Y|T], M) :- maxInList([Y|T], M1), max(X, M1, M).

max_slots_per_day(DaySched, Max) :- flatten(DaySched, D1), count_list(D1, D2), max_slots_per_dayHelper(D2, Max).
max_slots_per_dayHelper([],_).

max_slots_per_dayHelper([N|T],Max):- N=<Max, max_slots_per_dayHelper(T,Max).

%d
slot_assignment(0,L,L,[]).
slot_assignment(LabsNum ,TAs ,RemTAs ,[Name|T]):- 
LabsNum > 0, NewNum is LabsNum-1, slot_assignment(NewNum,TAs,RemTASFinal, T), member(ta(Name,_) ,RemTASFinal) , 
	\+ member(Name,T), ta_slot_assignment(RemTASFinal, RemTAs ,Name).

%e
ta_slot_assignment([ta(Name, Load)|T], [ta(Name, NewLoad)|T], Name) :-
Load > 0, NewLoad is Load -1.
ta_slot_assignment([ta(Name, Load)|T], [ta(Name,Load)|T1], AnotherName) :-
    ta_slot_assignment(T, T1, AnotherName).
	
	
