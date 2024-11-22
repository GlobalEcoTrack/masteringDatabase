CREATE OR REPLACE FUNCTION eco_track_validate_abbreviation (
    p_abbreviation IN eco_track_tb_state.abbreviation%TYPE
) RETURN BOOLEAN IS
BEGIN
    IF LENGTH(p_abbreviation) = 2 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

CREATE OR REPLACE PROCEDURE eco_track_insert_state (
    p_name         IN eco_track_tb_state.name%TYPE,
    p_abbreviation IN eco_track_tb_state.abbreviation%TYPE,
    p_price_kwh    IN eco_track_tb_state.price_kwh%TYPE
) AS
    v_is_valid_abbreviation BOOLEAN;
BEGIN
    v_is_valid_abbreviation := eco_track_validate_abbreviation(p_abbreviation);
    IF NOT v_is_valid_abbreviation THEN
        RAISE_APPLICATION_ERROR(-20001, 'A sigla deve conter exatamente 2 caracteres.');
    END IF;

    INSERT INTO eco_track_tb_state (name, abbreviation, price_kwh)
    VALUES (p_name, p_abbreviation, p_price_kwh);
END;

BEGIN
    eco_track_insert_state('TESTE', 'TT', 0.2);
END;

select * from eco_track_tb_state;

