-module(cafe).
-author("hamidreza.s@gmail.com").
-export([ingredients/1]).

-include_lib("eunit/include/eunit.hrl").

%% Time Complexity
%% =============================================
%% - Tokenizing: O(n)
%% - Fetching: O(n)
%% - Filtering: O(n)
%% - Joining: O(n)
%% - Sorting (merge sort): O(n log n)
%% - Total: O(4n)+ O(n log n) = O(n log n)

-spec ingredients(string()) -> string().
ingredients(OrderString) ->
    [Head|Tail] = string:tokens(OrderString, ","),

    {ok, Order} = order(Head),
    {ok, Allergies} = allergies(Tail),
    {ok, Ingredients} = ingredients(Order, Allergies),

    string:join(lists:sort(Ingredients), ",").

-spec ingredients(list(string()), sets:set()) -> {ok, list(string())}.
ingredients(Order, Allergies) ->
    {ok, [I || I <- Order, sets:is_element(I, Allergies) == false]}.

-spec allergies(list(string())) -> {ok, sets:set()}.
allergies(Items) ->
    allergies(Items, []).
allergies([], State) ->
    {ok, sets:from_list(State)};
allergies([[$-|Item]|Tail], State) ->
    allergies(Tail, [Item|State]).

-spec order(string()) -> {ok, list(string())} | not_found.
order("Classic") ->
    {ok, [
	  "strawberry",
	  "banana",
	  "pineapple",
	  "mango",
	  "peach",
	  "honey",
	  "ice",
	  "yogurt"
	 ]};
order("Forest Berry") ->
    {ok, [
	  "strawberry",
	  "raspberry",
	  "blueberry",
	  "honey",
	  "ice",
	  "yogurt"
	 ]};
order("Freezie") ->
    {ok, [
	  "blackberry",
	  "blueberry",
	  "black currant",
	  "grape juice",
	  "frozen yogurt"
	 ]};
order("Greenie") ->
    {ok, [
	  "green apple",
	  "kiwi",
	  "lime",
	  "avocado",
	  "spinach",
	  "ice",
	  "apple juice"
	 ]};
order("Vegan Delite") ->
    {ok, [
	  "strawberry",
	  "passion fruit",
	  "pineapple",
	  "mango",
	  "peach",
	  "ice",
	  "soy milk"
	 ]};
order("Just Desserts") ->
    {ok, [
	  "banana",
	  "ice cream",
	  "chocolate",
	  "peanut",
	  "cherry"
	 ]};
order(_) ->
    not_found.


classic_smoothie_test() ->
  ?assertEqual("banana,honey,ice,mango,peach,pineapple,strawberry,yogurt",
               ingredients("Classic")).

custom_classic_smoothie_test() ->
  ?assertEqual("banana,honey,ice,mango,peach,pineapple,yogurt",
               ingredients("Classic,-strawberry")).

just_desserts_test() ->
  ?assertEqual("banana,cherry,chocolate,ice cream,peanut",
               ingredients("Just Desserts")).

custom_just_desserts_test() ->
  ?assertEqual("banana,cherry,chocolate",
               ingredients("Just Desserts,-ice cream,-peanut")).
