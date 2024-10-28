/* Q10. Friend recommendation
\set personId 933
\set month 5
 */
select
    personId,
    personFirstName,
    personLastName,
    score,
    personGender,
    personCityName
from cypher($$
MATCH (p1:person)-[k1:person_knows_person]->(p2:person)-[k2:person_knows_person]->(p3:person),
      (p3)-[:person_islocatedin_city]->(pl:city)
WHERE p1.vertex_id = 28587303415817
AND p3.vertex_id <> 28587303415817
AND (
    (date_part('month', p3.birthday) = 3 AND date_part('day', p3.birthday) >= 21)
    OR
    (date_part('month', p3.birthday) = (3 % 12) + 1 AND date_part('day', p3.birthday) < 22)
)
RETURN
    p3.vertex_id AS personId,
    p3.firstname AS personFirstName,
    p3.lastname AS personLastName,
    0 AS score,
    p3.gender AS personGender,
    pl.name AS personCityName
ORDER BY
    p3.vertex_id ASC
LIMIT 10
$$) as (
    personId bigint,
    personFirstName varchar,
    personLastName varchar,
    score bigint,
    personGender varchar,
    personCityName varchar
);