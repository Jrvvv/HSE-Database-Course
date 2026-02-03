INSERT INTO student (id, name) VALUES
(10000000, generate_random_string(10)),
(10000001, generate_random_string(10)),
(10000002, generate_random_string(10)),
(10000003, generate_random_string(10)),
(10000004, generate_random_string(10));

INSERT INTO teacher (id, name) VALUES
(10000005, generate_random_string(10)),
(10000006, generate_random_string(10)),
(10000007, generate_random_string(10)),
(10000008, generate_random_string(10)),
(10000009, generate_random_string(10));

INSERT INTO subject (id, name, description) VALUES
(10000010, generate_random_string(15), generate_random_string(50)),
(10000011, generate_random_string(15), generate_random_string(50)),
(10000012, generate_random_string(15), generate_random_string(50)),
(10000013, generate_random_string(15), generate_random_string(50)),
(10000014, generate_random_string(15), generate_random_string(50));

INSERT INTO teaching (id, subject, teacher, period) VALUES
(1, 10000010, 10000005, tstzrange('2026-01-01 09:00:00+03', '2026-01-01 10:30:00+03')),
(2, 10000011, 10000006, tstzrange('2026-01-01 11:00:00+03', '2026-01-01 12:30:00+03')),
(3, 10000012, 10000007, tstzrange('2026-01-02 09:00:00+03', '2026-01-02 10:30:00+03')),
(4, 10000013, 10000008, tstzrange('2026-01-02 11:00:00+03', '2026-01-02 12:30:00+03')),
(5, 10000014, 10000009, tstzrange('2026-01-03 09:00:00+03', '2026-01-03 10:30:00+03'));

INSERT INTO exam (subject, teacher, student, score) VALUES
(10000010, 10000005, 10000000, 5),
(10000011, 10000006, 10000001, 7),
(10000012, 10000007, 10000002, 9),
(10000013, 10000008, 10000003, 6),
(10000014, 10000009, 10000004, 8);