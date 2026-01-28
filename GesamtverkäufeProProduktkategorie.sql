SELECT 
    p.kategorie,
    COUNT(v.verkauf_id) AS anzahl_verkaeufe,
    SUM(v.endbetrag) AS gesamtumsatz
FROM verkaeufe v
INNER JOIN produkte p ON v.produkt_id = p.produkt_id
WHERE v.verkaufsdatum >= DATE_TRUNC('quarter', CURRENT_DATE - INTERVAL '3 months')
  AND v.verkaufsdatum < DATE_TRUNC('quarter', CURRENT_DATE)
GROUP BY p.kategorie
HAVING COUNT(v.verkauf_id) > 10
ORDER BY gesamtumsatz DESC;̉̉