/* IS1. Profile of a person
\set personId 10995116277794
 */
SELECT firstName,
    lastName,
    birthday,
    locationIP,
    browserUsed,
    cityId,
    gender,
    creationDate
FROM cypher($$
MATCH (n:person)-[:person_islocatedin_city]->(p:city)
WHERE n.vertex_id = :personId
RETURN
    n.firstname AS firstName,
    n.lastname AS lastName,
    n.birthday AS birthday,
    n.locationip AS locationIP,
    n.browserused AS browserUsed,
    p.vertex_id AS cityId,
    n.gender AS gender,
    n.creationdate AS creationDate
$$) as (
    firstName varchar,
    lastName varchar,
    birthday date,
    locationIP varchar,
    browserUsed varchar,
    cityId bigint,
    gender varchar,
    creationDate timestamp
);
