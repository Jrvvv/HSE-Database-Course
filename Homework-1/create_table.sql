CREATE EXTENSION btree_gist;

CREATE SEQUENCE id_seq START WITH 10000000;

CREATE TABLE student (
    id int PRIMARY KEY DEFAULT nextval('id_seq'),
    name text
);

CREATE TABLE subject (
    id int PRIMARY KEY DEFAULT nextval('id_seq'),
    name text,
    description text
);

CREATE TABLE teacher (
    id int PRIMARY KEY DEFAULT nextval('id_seq'),
    name text
);

CREATE TABLE teaching (
    id int PRIMARY KEY,
    subject int NOT NULL REFERENCES subject(id),
    teacher int NOT NULL REFERENCES teacher(id),
    period tstzrange NOT NULL,

    EXCLUDE USING gist (
        teacher WITH =,
        period WITH && )
);

CREATE TABLE exam (
    id int PRIMARY KEY DEFAULT nextval('id_seq'),
    subject int NOT NULL REFERENCES subject(id),
    teacher int NOT NULL REFERENCES teacher(id),
    student int NOT NULL REFERENCES student(id),
    score int NOT NULL,

    UNIQUE(subject, student),

    CONSTRAINT score_range CHECK (score > 0 AND score <= 10)
);
