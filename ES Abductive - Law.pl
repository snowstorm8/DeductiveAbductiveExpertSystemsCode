% Declare observed/1 as dynamic to store evidence during a session.
:- dynamic(observed/1).

% --- Knowledge Base ---
% Each legal case is defined with a list of pieces of evidence that would support that case.
lawcase(theft, [suspect_at_crime_scene, possession_of_stolen_goods, no_valid_alibi, taken_property]).
lawcase(embezzlement, [unauthorized_transfer, missing_documents, unusual_account_activity, financial_gain]).
lawcase(fraud, [false_statements, manipulated_records, financial_gain, missing_documents]).
lawcase(robbery, [armed_presence, threat_or_force, taken_property, possession_of_stolen_goods, no_valid_alibi]).

% --- User Interaction ---
% ask_evidence/1: Prompt the user about a particular piece of evidence.
ask_evidence(Evidence) :-
    format('Is it true that ~w? (yes/no): ', [Evidence]),
    read(Response),
    ( Response == yes ->
        assertz(observed(Evidence))
    ;   true).

% gather_evidence/0: Query the user for evidence relevant to the knowledge base.
gather_evidence :-
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
    ask_evidence(taken_property).

% --- Abductive Reasoning Mechanism ---
%
% explanation_score/2: Calculates how many pieces of observed evidence match a given legal case.
legal_explanation_score(LawCase, Score) :-
    lawcase(LawCase, Evidences),
    findall(E, (observed(E), member(E, Evidences)), Matches),
    length(Matches, Score).

% abductive_explanation/1: Succeeds if a lawcase explains at least one observed piece of evidence.
abductive_explanation(LawCase) :-
    lawcase(LawCase, Evidences),
    observed(Evidence),
    member(Evidence, Evidences).

% --- Main Expert System ---
%
% run/0: Clears previous evidence, gathers new evidence, computes explanation scores,
% and outputs the legal case with the highest matching score as the best abductive explanation.
run :-
    retractall(observed(_)),
    gather_evidence,
    findall((Case, Score),
            (lawcase(Case, _), legal_explanation_score(Case, Score)),
            Candidates),
    sort(2, @>=, Candidates, Sorted),
    ( Sorted = [(BestCase, BestScore)|_] ->
          format('The best abductive legal explanation is: ~w (score: ~w).~n', [BestCase, BestScore])
    ;   format('No plausible legal explanation could be determined from the provided evidence.~n')
    ).



