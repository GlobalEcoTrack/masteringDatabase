CREATE OR REPLACE FUNCTION eco_track_validate_user_appliance (
    p_total_cost       IN eco_track_tb_user_appliance.total_cost%TYPE,
    p_total_consumption IN eco_track_tb_user_appliance.total_consumption%TYPE
) RETURN BOOLEAN IS
BEGIN
    IF p_total_cost IS NULL OR p_total_cost <= 0 THEN
        RETURN FALSE; 
    ELSIF p_total_consumption IS NULL OR p_total_consumption <= 0 THEN
        RETURN FALSE; 
    ELSE
        RETURN TRUE;
    END IF;
END;

CREATE OR REPLACE PROCEDURE eco_track_insert_user_appliance (
    p_association_date     IN eco_track_tb_user_appliance.association_date%TYPE,
    p_minutes_used_per_day IN eco_track_tb_user_appliance.minutes_used_per_day%TYPE,
    p_days_used_per_week   IN eco_track_tb_user_appliance.days_used_per_week%TYPE,
    p_total_consumption    IN eco_track_tb_user_appliance.total_consumption%TYPE,
    p_total_cost           IN eco_track_tb_user_appliance.total_cost%TYPE,
    p_user_id              IN eco_track_tb_user_appliance.user_id%TYPE,
    p_appliance_id         IN eco_track_tb_user_appliance.appliance_id%TYPE
) AS
    v_is_valid BOOLEAN;
    v_user_exists NUMBER;
    v_appliance_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_user_exists
    FROM eco_track_tb_user
    WHERE id = p_user_id;

    IF v_user_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Usuário não encontrado.');
    END IF;

    SELECT COUNT(*) INTO v_appliance_exists
    FROM eco_track_tb_appliance
    WHERE id = p_appliance_id;

    IF v_appliance_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Eletrodoméstico não encontrado.');
    END IF;

    v_is_valid := eco_track_validate_user_appliance(p_total_cost, p_total_consumption);

    IF NOT v_is_valid THEN
        RAISE_APPLICATION_ERROR(-20003, 'Total cost e total consumption devem ser maiores que zero e não nulos.');
    END IF;

    INSERT INTO eco_track_tb_user_appliance (
        association_date, minutes_used_per_day, days_used_per_week, total_consumption, total_cost, user_id, appliance_id
    ) VALUES (
        p_association_date, p_minutes_used_per_day, p_days_used_per_week, p_total_consumption, p_total_cost, p_user_id, p_appliance_id
    );
END;

BEGIN
    eco_track_insert_user_appliance(
        TO_DATE('2024-11-22', 'YYYY-MM-DD'),
        30,               
        5,               
        100,           
        50,           
        5,                
        1                
    );
END;
COMMIT;

SELECT * FROM eco_track_tb_user_appliance;








