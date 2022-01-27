% Copyright (c) Facebook, Inc. and its affiliates.
%
% This source code is licensed under the MIT license found in the
% LICENSE file in the root directory of this source tree.

-module(models_return_value).

-export([
    test_return_true_Ok/0,
    test_return_true_Bad/0,
    test_return_one_Ok/0,
    test_return_one_Bad/0,
    test_return_tuple_Ok/0,
    test_return_tuple_Bad/0,
    fp_test_return_nondet_Ok/0,
    test_return_nondet_Bad/0,
    test_nondet_atom_Ok/0,
    test_nondet_atom_Bad/0,
    test_nested_Ok/0,
    test_nested_Bad/0,
    test_select_arity0_Ok/0,
    test_select_arity0_Bad/0,
    test_select_arity1_Ok/0,
    test_select_arity1_Bad/0,
    test_select_arity2_Ok/0,
    test_select_arity2_Bad/0,
    test_select_arity3_Ok/0,
    test_select_arity3_Bad/0,
    test_select_arity4_Ok/0,
    test_select_arity4_Bad/0,
    fp_test_select_arity5_Ok/0,
    fn_test_select_arity5_Bad/0
]).

%%% Exported functions first.

test_return_true_Ok() ->
    case get_true() of
        true -> ok;
        _ -> warn(1)
    end.
test_return_true_Bad() ->
    case get_true() of
        true -> warn(1);
        _ -> ok
    end.

test_return_one_Ok() ->
    case get_one() of
        1 -> ok;
        _ -> warn(1)
    end.
test_return_one_Bad() ->
    case get_one() of
        1 -> warn(1);
        _ -> ok
    end.

test_return_tuple_Ok() ->
    case get_pair_true_nondet() of
        {true, _X} -> ok;
        _ -> warn(1)
    end.
test_return_tuple_Bad() ->
    case get_pair_true_nondet() of
        {true, _X} -> warn(1);
        _ -> ok
    end.

% FP: We should angelically assume that the returned value does not lead to error.
fp_test_return_nondet_Ok() ->
    case get_pair_true_nondet() of
        {_, 1} -> warn(1);
        _ -> ok
    end.
test_return_nondet_Bad() ->
    case get_pair_true_nondet() of
        {_, _} -> warn(1);
        _ -> ok
    end.

test_nondet_atom_Ok() ->
    case get_nondet_atom() of
        X when is_atom(X) -> ok;
        _ -> warn(1)
    end.
test_nondet_atom_Bad() ->
    case get_nondet_atom() of
        X when is_atom(X) -> warn(1);
        _ -> ok
    end.

test_nested_Ok() ->
    case get_nested() of
        {12345678901234567890, [], [_], [one, 2, {{}, -3}]} -> ok;
        _ -> warn(1)
    end.
test_nested_Bad() ->
    case get_nested() of
        {12345678901234567890, [], [_], [one, 2, {{}, -3}]} -> warn(1);
        _ -> ok
    end.

test_select_arity0_Ok() ->
    case get_arity() of
        0 -> ok;
        _ -> warn(1)
    end.
test_select_arity0_Bad() ->
    case get_arity() of
        0 -> warn(1);
        _ -> ok
    end.

test_select_arity1_Ok() ->
    case get_arity(1) of
        1 -> ok;
        _ -> warn(1)
    end.
test_select_arity1_Bad() ->
    case get_arity(1) of
        1 -> warn(1);
        _ -> ok
    end.

test_select_arity2_Ok() ->
    case get_arity(1, 2) of
        2 -> ok;
        _ -> warn(1)
    end.
test_select_arity2_Bad() ->
    case get_arity(1, 2) of
        2 -> warn(1);
        _ -> ok
    end.

test_select_arity3_Ok() ->
    case get_arity(1, 2, 3) of
        3 -> ok;
        _ -> warn(1)
    end.
test_select_arity3_Bad() ->
    case get_arity(1, 2, 3) of
        3 -> warn(1);
        _ -> ok
    end.

test_select_arity4_Ok() ->
    case get_arity(1, 2, 3, 4) of
        4 -> ok;
        _ -> warn(1)
    end.
test_select_arity4_Bad() ->
    case get_arity(1, 2, 3, 4) of
        4 -> warn(1);
        _ -> ok
    end.

%FP: arity problem in T110841433
fp_test_select_arity5_Ok() ->
    case get_arity(1, 2, 3, 4, 5) of
        5 -> ok;
        _ -> warn(1)
    end.

%FN: arity problem in T110841433
fn_test_select_arity5_Bad() ->
    case get_arity(1, 2, 3, 4, 5) of
        5 -> warn(1);
        _ -> ok
    end.

%%% Internal functions follow.

% Call this method with warn(1) to trigger a warning
warn(0) -> ok.

% Model in .inferconfig overrides with 'true'.
get_true() -> false.

% Model in .inferconfig overrides with '1'.
get_one() -> 0.

% Model in .inferconfig overrides with '{true,_}'.
get_pair_true_nondet() -> false.

% Model in .inferconfig overrides with a value known to be atom BUT unknown which atom.
get_nondet_atom() -> 1.

% Model in .inferconfig overrides with '{12345678901234567890,[],[_],[one,2,{{},-3}]}'.
get_nested() -> 0.

% Models in .inferconfig override with the proper arity (0, 1, 2, ...).
get_arity() -> bad.
get_arity(_) -> bad.
get_arity(_, _) -> bad.
get_arity(_, _, _) -> bad.
get_arity(_, _, _, _) -> bad.
get_arity(_, _, _, _, _) -> bad.
