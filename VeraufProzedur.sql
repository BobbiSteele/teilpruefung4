CREATE OR REPLACE PROCEDURE neuer_verkauf(
    p_kunden_id INTEGER,
    p_mitarbeiter_id INTEGER,
    p_produkt_id INTEGER,
    p_menge INTEGER,
    p_einzelpreis NUMERIC,
    p_rabatt_prozent NUMERIC DEFAULT 0,
    p_zahlungsmethode VARCHAR DEFAULT 'Kreditkarte'
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_aktueller_bestand INTEGER;
BEGIN
    IF NOT EXISTS(SELECT 1 FROM kunden WHERE kunden_id = p_kunden_id) THEN
        RAISE EXCEPTION 'Kunde mit ID % existiert nicht.', p_kunden_id;
    END IF;
    
    SELECT bestand INTO v_aktueller_bestand
    FROM produkte
    WHERE produkt_id = p_produkt_id;
    
    IF v_aktueller_bestand IS NULL THEN
        RAISE EXCEPTION 'Produkt mit ID % existiert nicht.', p_produkt_id;
    END IF;
    
    IF v_aktueller_bestand < p_menge THEN
        RAISE EXCEPTION 'Nicht genügend Bestand. Verfügbar: %, Angefordert: %',
            v_aktueller_bestand, p_menge;
    END IF;
    
    INSERT INTO verkaeufe (
        kunden_id,
        mitarbeiter_id,
        produkt_id,
        menge,
        einzelpreis,
        rabatt_prozent,
        zahlungsmethode
    ) VALUES (
        p_kunden_id,
        p_mitarbeiter_id,
        p_produkt_id,
        p_menge,
        p_einzelpreis,
        p_rabatt_prozent,
        p_zahlungsmethode
    );
    
    UPDATE produkte
    SET bestand = bestand - p_menge
    WHERE produkt_id = p_produkt_id;
    
END;
$$;