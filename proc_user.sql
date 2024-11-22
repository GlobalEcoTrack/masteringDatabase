CREATE OR REPLACE FUNCTION eco_track_validate_email (
    p_email IN eco_track_tb_user.email%TYPE
) RETURN BOOLEAN IS
BEGIN
    IF REGEXP_LIKE(
        p_email,
        '^[a-zA-Z._]+@[a-zA-Z._]+\.[a-zA-Z]{2,}$'
    ) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

CREATE OR REPLACE PROCEDURE eco_track_insert_user (
    p_name       IN eco_track_tb_user.name%TYPE,
    p_birth_date IN eco_track_tb_user.birth_date%TYPE,
    p_email      IN eco_track_tb_user.email%TYPE,
    p_password   IN eco_track_tb_user.password%TYPE,
    p_role       IN eco_track_tb_user.role%TYPE,
    p_state_id   IN eco_track_tb_user.state_id%TYPE
) AS
    v_is_valid_email BOOLEAN;
BEGIN
    v_is_valid_email := eco_track_validate_email(p_email);

    IF NOT v_is_valid_email THEN
        RAISE_APPLICATION_ERROR(-20001, 'E-mail inválido. Certifique-se de que segue o formato permitido (letras, underline, ponto antes do @ e após o @).');
    END IF;

    INSERT INTO eco_track_tb_user (
        name, birth_date, email, password, role, state_id
    ) VALUES (
        p_name, p_birth_date, p_email, p_password, p_role, p_state_id
    );
END;

BEGIN
    eco_track_insert_user(
        'João_Silva',
        TO_DATE('1990-05-20', 'YYYY-MM-DD'),
        'joaos.silva@example.com',
        'senha123',
        'ADMIN',
        1
    );
END;

select * from eco_track_tb_user;

