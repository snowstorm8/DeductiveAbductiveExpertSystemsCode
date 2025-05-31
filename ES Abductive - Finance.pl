% Declare observed/1 as dynamic to store observed indicators.
:- dynamic(observed/1).

% --- Knowledge Base ---
% Each financial market condition is defined with a list of associated indicators.
finance_condition(bull_market, [market_trending_upward, strong_earnings_report, low_interest_rates, high_investor_confidence]).
finance_condition(bear_market, [market_trending_downward, weak_earnings_report, rising_interest_rates, low_investor_confidence]).
finance_condition(volatile_market, [market_is_volatile, high_trading_volume, frequent_price_swings]).

% --- User Interaction ---
% ask_evidence/1: Prompt the user about a particular market indicator.
ask_evidence(Indicator) :-
    format('Is it true that ~w? (yes/no): ', [Indicator]),
    read(Response),
    ( Response == yes ->
        assertz(observed(Indicator))
    ;   true).

% gather_evidence/0: Query the user for evidence relevant to the knowledge base.
gather_evidence :-
    ask_evidence(market_trending_upward),
    ask_evidence(market_trending_downward),
    ask_evidence(market_is_volatile),
    ask_evidence(strong_earnings_report),
    ask_evidence(weak_earnings_report),
    ask_evidence(low_interest_rates),
    ask_evidence(rising_interest_rates),
    ask_evidence(high_investor_confidence),
    ask_evidence(low_investor_confidence),
    ask_evidence(high_trading_volume),
    ask_evidence(frequent_price_swings).

% --- Abductive Reasoning Mechanism ---
%
% explanation_score/2: Computes a score for how well a financial condition explains the observed indicators.
% The score is the count of observed indicators that are in the condition's list.
finance_explanation_score(Condition, Score) :-
    finance_condition(Condition, Indicators),
    findall(I, (observed(I), member(I, Indicators)), Matches),
    length(Matches, Score).

% --- Main Expert System ---
%
% run/0: Clears previous observations, gathers new evidence, computes explanation scores,
% and outputs the financial market condition with the highest matching score as the best abductive explanation.
run :-
    % Clear any previously observed indicators.
    retractall(observed(_)),

    % Gather market indicators interactively.
    gather_evidence,

    % Compute explanation scores for each candidate financial condition.
    findall((Condition, Score),
            (finance_condition(Condition, _), finance_explanation_score(Condition, Score)),
            Candidates),

    % Sort candidates in descending order by score.
    sort(2, @>=, Candidates, Sorted),

    % Select and output the best explanation (if any).
    ( Sorted = [(BestCondition, BestScore)|_] ->
          format('The best abductive explanation for the financial market is: ~w (score: ~w).~n', [BestCondition, BestScore])
    ;   format('No plausible financial explanation could be determined from the provided evidence.~n')
    ).
