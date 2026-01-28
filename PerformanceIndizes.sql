CREATE INDEX idx_produkte_kategorie ON produkte(kategorie);
CREATE INDEX idx_verkaeufe_produkt_id ON verkaeufe(produkt_id);
CREATE INDEX idx_verkaeufe_verkaufsdatum ON verkaeufe(verkaufsdatum);

CREATE INDEX idx_verkaeufe_mitarbeiter_id ON verkaeufe(mitarbeiter_id);
CREATE INDEX idx_verkaeufe_status ON verkaeufe(status);
