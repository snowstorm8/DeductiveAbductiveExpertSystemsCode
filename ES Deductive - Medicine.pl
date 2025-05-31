% Define dynamic predicate to store observed symptoms
:- dynamic(observed/1).

% --- User Interaction ---
% ask_symptom/1: Prompt user for a symptom and assert it if the answer is yes.
ask_symptom(Symptom) :-
    format('Does the patient have ~w? (yes/no): ', [Symptom]),
    read(Response),
    (Response == yes ->
        assertz(observed(Symptom))
    ;   true).

% --- Diagnostic Rules ---
% Rule: If the patient has fever and cough, then diagnose influenza.
diagnosis(influenza) :-
    observed(high_fever),
    observed(cough),
    observed(sore_throat),
    observed(fatigue).

% Rule: If the patient has a sore throat and no fever, then diagnose a common cold.
diagnosis(common_cold) :-
    observed(sneezing),
    observed(cough),
    observed(runny_nose),
    observed(mild_fever).

% Rule: If the patient has headache and no fever, then diagnose migraine.
diagnosis(migraine) :-
    observed(headache),
    observed(nausea),
    observed(sensitivity_to_light),
    observed(vomiting).

diagnosis(pneumonia) :-
    observed(mild_fever),
    observed(high_fever),
    observed(cough),
    observed(chest_pain),
    observed(shortness_of_breath),
    observed(fatigue).

% Fallback rule: If none of the specific conditions match, the diagnosis is unknown.
diagnosis(unknown).

% --- Main Expert System ---
run :-
    % Clear any previous observations
    retractall(observed(_)),

    % Ask about key symptoms
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
    ask_symptom(vomiting),

    % Use deductive rules to arrive at a diagnosis.
    diagnosis(Disease),
    format('The diagnosis is: ~w.~n', [Disease]).




