--ex 12
-- sa se afiseze numele clientului care a lasat  un review cu rating mai mare ca 5 la un restaurant din perth;
-- • operație join pe cel puțin 4 tabele
-- • filtrare la nivel de linii

SELECT
    c.nume
FROM
    restaurant r,
    review     re,
    client     c,
    locatie    l
WHERE
        re.cod_client = c.cod_client
    AND r.cod_locatie = l.cod_locatie
    AND re.cod_restaurant = r.cod_restaurant
    AND re.rating > 5
    AND lower(l.oras) = 'perth';

--sa se afiseze datele de expirare sortate crescator ale mailurilor detinute de angajatii din  primul restaurant construit 
--*ordonări
--* subcereri nesincronizate în care intervin cel puțin 3 tabele
--ecare locatie care e data lansarii primulu rest

SELECT
    l.cod_locatie,
    (
        SELECT
            MIN(e.datadeschidere)
        FROM
            restaurant e
        WHERE
            e.cod_restaurant = r.cod_restaurant
    )
FROM
    locatie    l,
    restaurant r
WHERE
    l.cod_locatie = r.cod_locatie;

SELECT
    dataexpirare
FROM
    email
WHERE
    cod_email IN (
        SELECT
            j.cod_email
        FROM
            detine j
        WHERE
            cod_angajat IN (
                SELECT
                    cod_angajat
                FROM
                    angajat
                WHERE
                    cod_restaurant IN (
                        SELECT
                            cod_restaurant
                        FROM
                            restaurant
                        WHERE
                            datadeschidere = (
                                SELECT
                                    MIN(r.datadeschidere)
                                FROM
                                    restaurant r
                            )
                    )
            )
    )
ORDER BY
    1;

--sa se selecteze numele si marirea de salariu aferenta vechimii mari in restaurant a angajatilor ale caror nr de telefon nu incep cu 2 sau se termina cu 3;
--*utilizarea a cel puțin 2 funcții pe șiruri de caractere, 2 funcții pe date calendaristice, a funcțiilor NVL și DECODE, a cel puțin unei expresii CASE

SELECT
    upper(nume),
    CASE round(months_between(sysdate, round(dataangajarii)))
        WHEN 9  THEN
            '45%'
        WHEN 10 THEN
            '50%'
        WHEN 8  THEN
            '40%'
        WHEN 7  THEN
            '35%'
        ELSE
            '0%'
    END
FROM
    angajat
WHERE
    NOT nvl(substr(nrtelefon, 1, 1), 3) = 2
        OR decode(instr(nrtelefon, '1', length(nrtelefon)), NULL, 1, instr(nrtelefon, '1', length(nrtelefon))) != 0;

--sa se afiseze cat a platit fiecare restaurant  pe ingrediente mai putin restaurantul cu cel suma salariilor cea mai mica
--* grupări de date, funcții grup, filtrare la nivel de grupuri
--* utilizarea a cel puțin 1 bloc de cerere (clauza WITH

WITH asd AS (
    SELECT
        r.cod_restaurant,
        (
            SELECT
                SUM(salariu)
            FROM
                angajat j
            WHERE
                j.cod_restaurant = r.cod_restaurant
        ) plata
    FROM
        restaurant r
), temp AS (
    SELECT
        i.cod_restaurant,
        SUM(cantitate *(
            SELECT
                pret
            FROM
                ingredient x
            WHERE
                i.cod_ingredient = x.cod_ingredient
        ))
    FROM
        inventar i
    GROUP BY
        i.cod_restaurant
    HAVING
        i.cod_restaurant != (
            SELECT
                a.cod_restaurant
            FROM
                asd a
            WHERE
                a.plata = (
                    SELECT
                        MIN(b.plata)
                    FROM
                        asd b
                )
        )
)
SELECT
    *
FROM
    temp;

--sa se electeze denumirea ingredientului ,specificul restaurantului si denumirea mancarii pentru toate comenzile facute de clientul cu cod 203
--* subcereri sincronizate în care intervin cel puțin 3 tabele
SELECT
    (
        SELECT
            denumiremancare
        FROM
            mancare
        WHERE
            cod_mancare = m.cod_mancare
    ),
    (
        SELECT
            denumireingredient
        FROM
            ingredient
        WHERE
            cod_ingredient = m.cod_ingredient
    ),
    (
        SELECT
            specificul
        FROM
            restaurant r,
            comanda    c
        WHERE
                r.cod_restaurant = c.cod_restaurant
            AND c.cod_comanda = m.cod_comanda
    )
FROM
    meniu m
WHERE
    cod_comanda IN (
        SELECT DISTINCT
            cod_comanda
        FROM
            comanda
        WHERE
            cod_client = 203
    );

--ex 13
--sa se adauge o stea la restaurantele care au un review de peste 7 si au servit minim o comanda
UPDATE restaurant
SET
    stele = stele + 1
WHERE
    cod_restaurant IN (
        SELECT DISTINCT
            r.cod_restaurant
        FROM
            review r
        WHERE
                r.rating > 7
            AND 1 <= (
                SELECT
                    COUNT(cod_comanda)
                FROM
                    comanda x
                WHERE
                    r.cod_restaurant = x.cod_restaurant
            )
    );

--sa se stearga apartenenta angajatilor cu mailuile ce au expirat de mai mult de 3 luni si sunt detinute de o singura persoana

DELETE FROM detine
WHERE
    cod_email IN (
        SELECT
            d.cod_email
        FROM
            detine d, email  e
        WHERE
                e.cod_email = d.cod_email
            AND months_between(sysdate, dataexpirare) >= 3
            AND (
                SELECT
                    COUNT(x.cod_angajat)
                FROM
                    detine x
                WHERE
                    x.cod_email = e.cod_email
            ) = 1
    );
--sa se adauge 4 lei la pretul tututor mancarurilor ce contin lapte
UPDATE mancare
SET
    pret = pret + 4
WHERE
    cod_mancare IN (
        SELECT UNIQUE
            m.cod_mancare
        FROM
            meniu m
        WHERE
            EXISTS (
                SELECT
                    '1'
                FROM
                    ingredient i
                WHERE
                        lower(denumireingredient) = 'ou'
                    AND i.cod_ingredient = m.cod_ingredient
            )
    );
--ex 16
--Division --sa se afiseze codul mancarurilor care contin toate ingredientele nealergene 
SELECT
    *
FROM
    mancare
WHERE
    cod_mancare NOT IN (
        SELECT
            asd.cod_mancare
        FROM
            (
                SELECT
                    *
                FROM
                    (
                        SELECT
                            cod_ingredient
                        FROM
                            ingredient
                        WHERE
                            estealergen = 0
                    ), (
                        SELECT DISTINCT
                            cod_mancare
                        FROM
                            meniu
                    )
                MINUS
                SELECT
                    cod_ingredient, cod_mancare
                FROM
                    meniu
            ) asd
    );

--Division -- sa se afiseze angajatii care detin toate mailurile 
SELECT
    *
FROM
    angajat
WHERE
    cod_angajat NOT IN (
        SELECT
            asd.cod_angajat
        FROM
            (
                SELECT
                    *
                FROM
                    (
                        SELECT DISTINCT
                            cod_email
                        FROM
                            detine
                    ) x, (
                        SELECT
                            cod_angajat
                        FROM
                            angajat
                    ) y
                MINUS
                SELECT
                    *
                FROM
                    detine
            ) asd
    );

--outer join pe minim 4 tabele
--sa se afiseze cati oameni lucreaza in fiecare locatie si cate review-uri cumulative au restaurantele din locatiile respective
SELECT
    l.cod_locatie,
    COUNT(cod_angajat),
    COUNT(cod_review)
FROM
    angajat    a,
    restaurant r,
    review     w,
    locatie    l
WHERE
        l.cod_locatie = r.cod_locatie (+)
    AND w.cod_restaurant (+) = r.cod_restaurant
    AND a.cod_restaurant (+) = r.cod_restaurant
GROUP BY
    l.cod_locatie;