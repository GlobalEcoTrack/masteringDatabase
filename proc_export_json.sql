SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE eco_track_export_user_appliance_data (
    p_user_id IN NUMBER,
    p_json OUT CLOB
) AS
BEGIN
    -- Exibe mensagem de início para depuração
    DBMS_OUTPUT.PUT_LINE('Iniciando a geração do JSON para o usuário: ' || p_user_id);
    
    -- Realiza a consulta e gera o JSON
    SELECT JSON_ARRAYAGG(
               JSON_OBJECT(
                   'appliance_id'        VALUE APPLIANCE_ID,
                   'quantity'             VALUE COUNT(*),
                   'total_consumption'    VALUE ROUND(SUM(TOTAL_CONSUMPTION), 2),
                   'total_cost'           VALUE ROUND(SUM(TOTAL_COST), 2)
               )
           ) 
    INTO p_json
    FROM ECO_TRACK_TB_USER_APPLIANCE
    WHERE USER_ID = p_user_id
    GROUP BY APPLIANCE_ID
    ORDER BY APPLIANCE_ID;

    -- Verifica se o JSON foi gerado e, caso não tenha dados, atribui uma mensagem
    IF p_json IS NULL OR p_json = '[]' THEN
        p_json := '{"messagem": "Nenhum dado foi encontrado para esse user"}';
    END IF;

    -- Verifica se o JSON foi gerado e exibe
    DBMS_OUTPUT.PUT_LINE('JSON gerado: ' || p_json);

EXCEPTION
    WHEN OTHERS THEN
        -- Caso ocorra um erro, retorna um erro em formato JSON e exibe na saída
        p_json := '{"error": "An error occurred while processing the request."}';
        DBMS_OUTPUT.PUT_LINE('Erro ao gerar JSON: ' || SQLERRM);
        RAISE;
END;


SET SERVEROUTPUT ON;

DECLARE
    v_json CLOB;
BEGIN
    eco_track_export_user_appliance_data(1, v_json);
    DBMS_OUTPUT.PUT_LINE('Resultado final do JSON: ' || v_json); -- Exibe o JSON final
END;




