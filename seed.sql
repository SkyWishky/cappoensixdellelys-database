CREATE TABLE pet (
    id              BIGSERIAL    PRIMARY KEY,
    name            VARCHAR(30)  NOT NULL,
    species         VARCHAR(20)  NOT NULL CHECK (species IN ('CAT', 'DOG', 'DUCK', 'DRAGON', 'BLOB')),
    fullness        INTEGER      NOT NULL CHECK (fullness  BETWEEN 0 AND 100),
    happiness       INTEGER      NOT NULL CHECK (happiness BETWEEN 0 AND 100),
    energy          INTEGER      NOT NULL CHECK (energy    BETWEEN 0 AND 100),
    alive           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_decay_at   TIMESTAMPTZ  NOT NULL DEFAULT now(),
    died_at         TIMESTAMPTZ
);

INSERT INTO pet (name, species, fullness, happiness, energy) VALUES
    ('Segfault',   'CAT',    80, 70, 90),
    ('Kubernetto', 'DOG',    60, 95, 50),
    ('Quackers',   'DUCK',   90, 40, 75),
    ('Merge Conflict', 'DRAGON', 35, 55, 25),
    ('YAMLbert',   'BLOB',   50, 50, 50);

INSERT INTO pet (name, species, fullness, happiness, energy, alive, died_at) VALUES
    ('Friday Deploy', 'DUCK', 0, 12, 3, FALSE, now());
