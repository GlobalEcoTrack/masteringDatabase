CREATE OR REPLACE FUNCTION eco_track_validate_appliance (
    p_name IN eco_track_tb_appliance.name%TYPE,
    p_kw   IN eco_track_tb_appliance.kw%TYPE
) RETURN BOOLEAN IS
BEGIN
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        RETURN FALSE;
    ELSIF p_kw <= 0 THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END;

CREATE OR REPLACE PROCEDURE eco_track_insert_appliance (
    p_name IN eco_track_tb_appliance.name%TYPE,
    p_kw   IN eco_track_tb_appliance.kw%TYPE
) AS
    v_is_valid BOOLEAN;
BEGIN
    v_is_valid := eco_track_validate_appliance(p_name, p_kw);

    IF NOT v_is_valid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nome não pode ser nulo ou vazio e kW deve ser maior que zero.');
    END IF;

    INSERT INTO eco_track_tb_appliance (
        name, kw
    ) VALUES (
        p_name, p_kw
    );
END;

BEGIN
    eco_track_insert_appliance(
        'Caixa de Som',
        1.50
    );
END;

select * from eco_track_tb_appliance;




