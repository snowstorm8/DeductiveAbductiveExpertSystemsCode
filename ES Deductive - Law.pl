% Define a dynamic predicate to store observed evidence.
:- dynamic(observed/1).

% --- User Interaction ---
% ask_evidence/1: Prompt the user about a particular piece of evidence and assert it if the answer is yes.
ask_evidence(Evidence) :-
    format('Is it true that ~w? (yes/no): ', [Evidence]),
    read(Response),
    (Response == yes ->
        assertz(observed(Evidence))
    ;   true).

% --- Legal Assessment Rules ---
crime(theft) :-
    observed(suspect_at_crime_scene),
    observed(possession_of_stolen_goods),
    observed(no_valid_alibi),
    observed(taken_property).

crime(embezzlement) :-
    observed(unauthorized_transfer),
    observed(missing_documents),
    observed(unusual_account_activity),
    observed(financial_gain).

crime(fraud) :-
    observed(false_statements),
    observed(missing_documents),
    observed(manipulated_records),
    observed(financial_gain).

crime(robbery) :-
    observed(armed_presence),
    observed(threat_or_force),
    observed(taken_property),
    observed(possession_of_stolen_goods),
    observed(no_valid_alibi).

% Fallback rule: If the evidence is inconclusive, the outcome is
% undetermined.
crime(undetermined).

% --- Main Expert System ---
run :-
    % Clear any previous evidence.
    retractall(observed(_)),

    % Ask about key pieces of evidence.
    ask_evidence(suspect_at_crime_scene),
    ask_evidence(possession_of_stolen_goods),
    ask_evidence(no_valid_alibi),
    ask_evidence(unauthorized_transfer),
    ask_evidence(missing_documents),
    ask_evidence(unusual_account_activity),
    ask_evidence(false_statements),
    ask_evidence(manipulated_records),
    ask_evidence(financial_gain),
    ask_evidence(armed_presence),
    ask_evidence(threat_or_force),
    ask_evidence(taken_property),

    % Use deductive rules to arrive at a legal assessment.
    crime(Outcome),
    format('The legal assessment is: ~w.~n', [Outcome]).

