CREATE OR REPLACE FUNCTION test() RETURNS VOID AS $$
DECLARE
a INTEGER;
BEGIN
    SELECT tarif_plein into a from spectacle where representation.id_spectacle = spectacle.id_spectacle;
    raise notice 'Value: %', a;
END;
$$ LANGUAGE plpgsql;

select test();
