DROP TABLE eco_track_tb_appliance CASCADE CONSTRAINTS;
DROP TABLE eco_track_tb_state CASCADE CONSTRAINTS;
DROP TABLE eco_track_tb_user CASCADE CONSTRAINTS;
DROP TABLE eco_track_tb_user_appliance CASCADE CONSTRAINTS;

CREATE TABLE eco_track_tb_appliance (
    id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(255 CHAR) NOT NULL UNIQUE,
    kw   NUMBER NOT NULL
);

CREATE TABLE eco_track_tb_state (
    id           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         VARCHAR2(255 CHAR) NOT NULL UNIQUE,
    abbreviation VARCHAR2(2 CHAR) NOT NULL UNIQUE,
    price_kwh    NUMBER
);

CREATE TABLE eco_track_tb_user (
    id         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name       VARCHAR2(255 CHAR) NOT NULL,
    birth_date DATE NOT NULL,
    email      VARCHAR2(255 CHAR) NOT NULL UNIQUE,
    password   VARCHAR2(255 CHAR) NOT NULL,
    role       VARCHAR2(255 CHAR) NOT NULL,
    state_id   NUMBER NOT NULL
);

CREATE TABLE eco_track_tb_user_appliance (
    id                   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    association_date     DATE NOT NULL,
    minutes_used_per_day NUMBER NOT NULL,
    days_used_per_week   INTEGER NOT NULL,
    total_consumption    NUMBER NOT NULL,
    total_cost           NUMBER NOT NULL,
    user_id              NUMBER NOT NULL,
    appliance_id         NUMBER NOT NULL
);

ALTER TABLE eco_track_tb_user_appliance
    ADD CONSTRAINT e_t_tb_user_app_e_t_tb_app_fk FOREIGN KEY ( appliance_id )
        REFERENCES eco_track_tb_appliance ( id );

ALTER TABLE eco_track_tb_user_appliance
    ADD CONSTRAINT e_t_tb_user_app_e_t_tb_user_fk FOREIGN KEY ( user_id )
        REFERENCES eco_track_tb_user ( id );

ALTER TABLE eco_track_tb_user
    ADD CONSTRAINT eco_t_tb_user_e_t_tb_state_fk FOREIGN KEY ( state_id )
        REFERENCES eco_track_tb_state ( id );
        
COMMIT;