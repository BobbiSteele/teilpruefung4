CREATE OR REPLACE FUNCTION mitarbeiter_gesamtumsatz(
    p_mitarbeiter_id INTEGER
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_gesamtumsatz NUMERIC;
BEGIN
    SELECT COALESCE(SUM(endbetrag), 0)
    INTO v_gesamtumsatz
    FROM verkaeufe
    WHERE mitarbeiter_id = p_mitarbeiter_id
      AND status = 'Abgeschlossen';
    
    RETURN v_gesamtumsatz;
END;
$$;