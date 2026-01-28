SELECT 
    p.kategorie,
    COUNT(v.verkauf_id) AS anzahl_verkaeufe,
    SUM(v.endbetrag) AS gesamtumsatz,
    ROUND(AVG(v.endbetrag), 2) AS durchschnittlicher_wert
FROM verkaeufe v
INNER JOIN produkte p ON v.produkt_id = p.produkt_id
WHERE v.verkaufsdatum >= DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL '3 months'
  AND v.verkaufsdatum < DATE_TRUNC('quarter', CURRENT_DATE)
  AND v.status = 'Abgeschlossen'
GROUP BY p.kategorie
HAVING COUNT(v.verkauf_id) > 10
ORDER BY gesamtumsatz DESC;̉̉