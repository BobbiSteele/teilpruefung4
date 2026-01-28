CREATE OR REPLACE VIEW v_management_kennzahlen AS
SELECT 
    COUNT(verkauf_id) AS anzahl_verkaeufe,
    SUM(endbetrag) AS gesamtumsatz,
    AVG(endbetrag) AS durchschnittlicher_verkaufswert
FROM verkaeufe
WHERE status = 'Abgeschlossen';

CREATE OR REPLACE VIEW v_mitarbeiter_performance AS
SELECT 
    m.mitarbeiter_id,
    m.vorname || ' ' || m.nachname AS mitarbeiter_name,
    m.position,
    COUNT(v.verkauf_id) AS anzahl_verkaeufe,
    COALESCE(SUM(v.endbetrag), 0) AS gesamtumsatz,
    COALESCE(AVG(v.endbetrag), 0) AS durchschnittlicher_verkaufswert
FROM mitarbeiter m
LEFT JOIN verkaeufe v ON m.mitarbeiter_id = v.mitarbeiter_id
    AND v.status = 'Abgeschlossen'
GROUP BY m.mitarbeiter_id, m.vorname, m.nachname, m.position
ORDER BY gesamtumsatz DESC;