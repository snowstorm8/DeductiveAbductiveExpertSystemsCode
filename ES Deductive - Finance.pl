% Define a dynamic predicate to store observed market conditions.
:- dynamic(observed/1).

% --- User Interaction ---
% ask_indicator/1: Prompt the user about a particular market indicator and assert it if the answer is yes.
ask_indicator(Indicator) :-
    format('Is it true that ~w? (yes/no): ', [Indicator]),
    read(Response),
    (Response == yes ->
        assertz(observed(Indicator))
    ;   true).

% --- Market Recommendation Rules ---
market_state(bull_market) :-
    observed(market_trending_upward),
    observed(strong_earnings_report),
    observed(low_interest_rates),
    observed(high_investor_confidence).

market_state(bear_market) :-
    observed(market_trending_downward),
    observed(weak_earnings_report),
    observed(rising_interest_rates),
    observed(low_investor_confidence).

market_state(volatile_market) :-
    observed(market_is_volatile),
    observed(high_trading_volume),
    observed(frequent_price_swings).

% Fallback rule: If none of the above conditions apply, no clear
% market_state is given.
market_state(no_recommendation).

% --- Main Expert System ---
run :-
    % Clear any previous observations.
    retractall(observed(_)),

    % Ask about key market indicators.
    ask_indicator(market_trending_upward),
    ask_indicator(market_trending_downward),
    ask_indicator(market_is_volatile),
    ask_indicator(strong_earnings_report),
    ask_indicator(weak_earnings_report),
    ask_indicator(low_interest_rates),
    ask_indicator(rising_interest_rates),
    ask_indicator(high_investor_confidence),
    ask_indicator(low_investor_confidence),
    ask_indicator(high_trading_volume),
    ask_indicator(frequent_price_swings),

    % Use deductive rules to arrive at a recommendation.
    market_state(Decision),
    format('The market state is: ~w.~n', [Decision]).




