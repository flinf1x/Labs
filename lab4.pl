% Симптомы

symptom(router_on).
symptom(network_visible).
symptom(connected).
symptom(no_internet).
symptom(other_devices_have_internet).
symptom(cannot_connect).
symptom(low_signal).
symptom(router_hot).
symptom(indicator_red).
symptom(indicator_off).
symptom(frequent_disconnects).
symptom(asks_password_again).
symptom(connected_no_ip).
symptom(slow_speed).
symptom(only_one_device_problem).
symptom(all_devices_problem).

% Возможные проблемы

problem(router_power_issue) :-
    \+ symptom(router_on).

problem(router_failure) :-
    symptom(router_on),
    \+ symptom(network_visible).

problem(wrong_password) :-
    symptom(network_visible),
    symptom(cannot_connect),
    symptom(asks_password_again).

problem(provider_issue) :-
    symptom(connected),
    symptom(no_internet),
    \+ symptom(other_devices_have_internet).

problem(device_network_settings_issue) :-
    symptom(connected),
    symptom(no_internet),
    symptom(other_devices_have_internet).

problem(weak_signal) :-
    symptom(network_visible),
    symptom(low_signal).

problem(router_overheating) :-
    symptom(router_hot),
    symptom(frequent_disconnects).

problem(line_problem) :-
    symptom(indicator_red),
    symptom(no_internet).

problem(ip_configuration_error) :-
    symptom(connected_no_ip).

problem(channel_interference) :-
    symptom(low_signal),
    symptom(slow_speed),
    symptom(frequent_disconnects).

% Рекомендации

advice(check_power_cable) :-
    problem(router_power_issue).

advice(restart_router) :-
    problem(router_failure).

advice(check_password) :-
    problem(wrong_password).

advice(contact_provider) :-
    problem(provider_issue).

advice(check_ip_dns_settings) :-
    problem(device_network_settings_issue).

advice(move_closer_to_router) :-
    problem(weak_signal).

advice(turn_off_router_for_cooling) :-
    problem(router_overheating).

advice(check_provider_line) :-
    problem(line_problem).

advice(reset_network_settings) :-
    problem(ip_configuration_error).

advice(change_wifi_channel) :-
    problem(channel_interference).
