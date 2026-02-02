CREATE INDEX idx_produkte_kategorie ON produkte(kategorie);
CREATE INDEX idx_verkaeufe_composite ON verkaeufe(status, verkaufsdatum, produkt_id);
CREATE INDEX idx_verkaeufe_verkaufsdatum ON verkaeufe(verkaufsdatum);

CREATE INDEX idx_verkaeufe_mitarbeiter_id ON verkaeufe(mitarbeiter_id);
