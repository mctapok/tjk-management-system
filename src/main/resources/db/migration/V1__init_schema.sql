-- V1__init_schema.sql
-- Equipment Tracker MVP — PostgreSQL Schema

-- ==================== USERS ====================
CREATE TABLE users (
                       id          BIGSERIAL PRIMARY KEY,
                       full_name   VARCHAR(150)        NOT NULL,
                       email       VARCHAR(150)        NOT NULL UNIQUE,
                       password    VARCHAR(255)        NOT NULL,
                       role        VARCHAR(30)         NOT NULL DEFAULT 'OPERATOR', -- ADMIN, STOREKEEPER, OPERATOR
                       phone       VARCHAR(30),
                       is_active   BOOLEAN             NOT NULL DEFAULT TRUE,
                       created_at  TIMESTAMP           NOT NULL DEFAULT NOW(),
                       updated_at  TIMESTAMP           NOT NULL DEFAULT NOW()
);

-- ==================== EQUIPMENT CATALOG ====================
-- Справочник типов оборудования (Камера Sony FX3, Петличка Rode, ...)
CREATE TABLE equipment_type (
                                id           BIGSERIAL PRIMARY KEY,
                                name         VARCHAR(150)    NOT NULL,           -- "Камера", "Микрофон", "Петличка"
                                category     VARCHAR(50)     NOT NULL,           -- CAMERA, MICROPHONE, LAVALIER, BATTERY, WINDSCREEN, MEMORY_CARD, TRIPOD, CABLE, CASE, OTHER
                                description  TEXT,
                                created_at   TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- Конкретные единицы оборудования (серийный номер, состояние)
CREATE TABLE equipment (
                           id               BIGSERIAL PRIMARY KEY,
                           type_id          BIGINT          NOT NULL REFERENCES equipment_type(id),
                           serial_number    VARCHAR(100)    UNIQUE,
                           inventory_number VARCHAR(100)    UNIQUE,          -- внутренний инвентарный номер
                           name             VARCHAR(200)    NOT NULL,        -- "Sony FX3 #001"
                           status           VARCHAR(30)     NOT NULL DEFAULT 'AVAILABLE', -- AVAILABLE, IN_KIT, IN_REPAIR, WRITTEN_OFF
                           condition        VARCHAR(30)     NOT NULL DEFAULT 'GOOD',      -- NEW, GOOD, FAIR, DAMAGED, BROKEN
                           notes            TEXT,
                           purchase_date    DATE,
                           created_at       TIMESTAMP       NOT NULL DEFAULT NOW(),
                           updated_at       TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- ==================== KITS ====================
-- Съёмочный комплект (набор оборудования)
CREATE TABLE kit (
                     id           BIGSERIAL PRIMARY KEY,
                     kit_number   VARCHAR(50)     NOT NULL UNIQUE,    -- "KIT-001", "KIT-002"
                     name         VARCHAR(150)    NOT NULL,           -- "Комплект репортёра #1"
                     status       VARCHAR(30)     NOT NULL DEFAULT 'AVAILABLE', -- AVAILABLE, ISSUED, IN_REPAIR, INCOMPLETE
                     description  TEXT,
                     created_at   TIMESTAMP       NOT NULL DEFAULT NOW(),
                     updated_at   TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- Состав комплекта (какое оборудование входит)
CREATE TABLE kit_item (
                          id            BIGSERIAL PRIMARY KEY,
                          kit_id        BIGINT  NOT NULL REFERENCES kit(id),
                          equipment_id  BIGINT  NOT NULL REFERENCES equipment(id),
                          is_required   BOOLEAN NOT NULL DEFAULT TRUE,     -- обязательная позиция комплекта
                          UNIQUE(kit_id, equipment_id)
);

-- ==================== LOANS (ВЫДАЧА) ====================
-- Факт выдачи комплекта оператору
CREATE TABLE loan (
                      id               BIGSERIAL PRIMARY KEY,
                      kit_id           BIGINT          NOT NULL REFERENCES kit(id),
                      operator_id      BIGINT          NOT NULL REFERENCES users(id),  -- кто взял
                      issued_by_id     BIGINT          NOT NULL REFERENCES users(id),  -- кто выдал (кладовщик)
                      returned_to_id   BIGINT          REFERENCES users(id),           -- кто принял при возврате
                      assignment       VARCHAR(300),                                    -- задание/съёмка (Репортаж "Выборы 2024")
                      issued_at        TIMESTAMP       NOT NULL DEFAULT NOW(),
                      planned_return   TIMESTAMP,                                      -- плановая дата возврата
                      returned_at      TIMESTAMP,                                      -- фактический возврат
                      status           VARCHAR(30)     NOT NULL DEFAULT 'ACTIVE',      -- ACTIVE, RETURNED, OVERDUE, LOST
                      issue_notes      TEXT,                                           -- примечания при выдаче
                      return_notes     TEXT,                                           -- примечания при возврате
                      created_at       TIMESTAMP       NOT NULL DEFAULT NOW(),
                      updated_at       TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- Состояние каждой позиции при выдаче и возврате
CREATE TABLE loan_item (
                           id                  BIGSERIAL PRIMARY KEY,
                           loan_id             BIGINT      NOT NULL REFERENCES loan(id),
                           equipment_id        BIGINT      NOT NULL REFERENCES equipment(id),
                           condition_on_issue  VARCHAR(30) NOT NULL DEFAULT 'GOOD',  -- NEW, GOOD, FAIR, DAMAGED
                           condition_on_return VARCHAR(30),                          -- заполняется при возврате
                           is_returned         BOOLEAN     NOT NULL DEFAULT FALSE,
                           damage_description  TEXT,                                 -- описание повреждений при возврате
                           UNIQUE(loan_id, equipment_id)
);

-- ==================== REPAIR LOG ====================
CREATE TABLE repair_log (
                            id            BIGSERIAL PRIMARY KEY,
                            equipment_id  BIGINT      NOT NULL REFERENCES equipment(id),
                            reported_by   BIGINT      NOT NULL REFERENCES users(id),
                            description   TEXT        NOT NULL,
                            status        VARCHAR(30) NOT NULL DEFAULT 'PENDING', -- PENDING, IN_PROGRESS, DONE, WRITTEN_OFF
                            started_at    TIMESTAMP,
                            completed_at  TIMESTAMP,
                            cost          DECIMAL(10,2),
                            notes         TEXT,
                            created_at    TIMESTAMP   NOT NULL DEFAULT NOW()
);

-- ==================== INDEXES ====================
CREATE INDEX idx_loan_operator    ON loan(operator_id);
CREATE INDEX idx_loan_kit         ON loan(kit_id);
CREATE INDEX idx_loan_status      ON loan(status);
CREATE INDEX idx_loan_issued_at   ON loan(issued_at);
CREATE INDEX idx_equipment_status ON equipment(status);
CREATE INDEX idx_kit_status       ON kit(status);

-- ==================== SEED DATA ====================
INSERT INTO users (full_name, email, password, role) VALUES
                                                         ('Администратор', 'admin@tracker.local', '$2a$10$placeholder_hash', 'ADMIN'),
                                                         ('Кладовщик', 'store@tracker.local', '$2a$10$placeholder_hash', 'STOREKEEPER');

INSERT INTO equipment_type (name, category) VALUES
                                                ('Камера', 'CAMERA'),
                                                ('Микрофон накамерный', 'MICROPHONE'),
                                                ('Петличный микрофон', 'LAVALIER'),
                                                ('Аккумулятор для камеры', 'BATTERY'),
                                                ('Ветрозащита', 'WINDSCREEN'),
                                                ('Карта памяти', 'MEMORY_CARD'),
                                                ('Штатив', 'TRIPOD'),
                                                ('Кейс для транспортировки', 'CASE');
