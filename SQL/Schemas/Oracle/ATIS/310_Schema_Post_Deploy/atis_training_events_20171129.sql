
DELETE FROM atis_training_events;

INSERT INTO atis_training_events (training_event_id, training_event_name, 
    expiration_length, expiration_length_units) 
          SELECT 1, 'APFT', 180, 'D' FROM DUAL 
UNION ALL SELECT 2, 'WPN Q', 180, 'D' FROM DUAL 
UNION ALL SELECT 3, 'HT/WT', 180, 'D' FROM DUAL ;


SELECT training_event_id, training_event_name, 
    expiration_length, expiration_length_units 
FROM atis_training_events;

