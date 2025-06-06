% Declare observed/1 as dynamic so we can record symptoms during a session.
:- dynamic(observed/1).

% --- Knowledge Base ---
% Define diseases with their associated symptom lists.
disease(influenza, [high_fever, cough, sore_throat, fatigue]).
disease(common_cold, [cough, sneezing, runny_nose, mild_fever]).
disease(migraine, [headache, nausea, sensitivity_to_light, vomiting]).
disease(pneumonia, [mild_fever, cough, chest_pain, shortness_of_breath, fatigue]).

% --- User Interaction ---
% ask_symptom/1: Prompt the user about a symptom; if answered yes, record the observation.
ask_symptom(Symptom) :-
    format('Is the patient experiencing ~w? (yes/no): ', [Symptom]),
    read(Response),
    ( Response == yes ->
        assertz(observed(Symptom))
    ;   true).

% Gather a set of symptoms from the user.
gather_symptoms :-
    ask_symptom(low_fever),
    ask_symptom(mild_fever),
    ask_symptom(high_fever),
    ask_symptom(cough),
    ask_symptom(sore_throat),
    ask_symptom(sneezing),
    ask_symptom(runny_nose),
    ask_symptom(headache),
    ask_symptom(nausea),
    ask_symptom(sensitivity_to_light),
    ask_symptom(chest_pain),
    ask_symptom(shortness_of_breath),
    ask_symptom(fatigue),
    ask_symptom(vomiting).

% --- Abductive Reasoning Mechanism ---
%
% explanation_score/2: Computes a score for how well a disease explains the observed symptoms.
% The score is the count of observed symptoms that are in the disease's symptom list.
explanation_score(Disease, Score) :-
    disease(Disease, Symptoms),
    findall(S, (observed(S), member(S, Symptoms)), Matches),
    length(Matches, Score).

% abductive_explanation/1: Finds a candidate disease that explains at least one observed symptom.
abductive_explanation(Disease) :-
    disease(Disease, Symptoms),
    observed(Symptom),
    member(Symptom, Symptoms).

% --- Main Expert System ---
%
% run/0: Clears previous observations, gathers current symptoms, computes explanation scores
% for each disease, and outputs the disease with the highest matching score as the best abductive explanation.
run :-
    % Clear any previously observed symptoms.
    retractall(observed(_)),

    % Gather symptoms interactively from the user.
    gather_symptoms,

    % Collect candidate diseases with their explanation scores.
    findall((Disease, Score),
            (disease(Disease, _), explanation_score(Disease, Score)),
            Candidates),

    % Sort the candidates in descending order by score.
    sort(2, @>=, Candidates, Sorted),

    % Select the best explanation (if any).
    ( Sorted = [(BestDisease, BestScore)|_] ->
          format('The best abductive explanation is: ~w (score: ~w).~n', [BestDisease, BestScore])
    ;   format('No plausible explanation could be determined from the provided symptoms.~n')
    ).


