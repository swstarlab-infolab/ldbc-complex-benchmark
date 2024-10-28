/* Q3. Friends and friends of friends that have been to given countries
\set personId 933
\set countryXName 'India' 'El_Salvador'
\set countryYName 'China' 'Philippines'
\set startDate '2010-10-01'
\set durationDays 31
 */ 
SELECT friendId,
    friendFirstName,
    friendLastName,
    ct1,
    ct2,
    total
FROM cypher($$
MATCH (p1:person)-[:person_knows_person]->(p2:person),
      (p2)<-[:message_hascreator_person]-(m1:message)-[:message_islocatedin_country]->(pl1:country),
      (p2)<-[:message_hascreator_person]-(m2:message)-[:message_islocatedin_country]->(pl2:country)
WHERE p1.vertex_id = 32985349348881
AND pl1.name = 'Oman'
AND pl2.name = 'Azerbaijan'
AND m1.creationdate >= to_timestamp(1325376000)
AND m1.creationdate < (to_timestamp(1325376000)::timestamp + 1060 * '1 day'::interval)
AND m2.creationdate >= to_timestamp(1325376000)
AND m2.creationdate < (to_timestamp(1325376000)::timestamp + 1060 * '1 day'::interval)
RETURN
    p2.vertex_id AS friendId,
    p2.firstname AS friendFirstName,
    p2.lastname AS friendLastName,
    count(m1) AS ct1,
    count(m2) AS ct2,
    count(m1) + count(m2) AS total
ORDER BY
    count(m1) + count(m2) DESC,
    p2.vertex_id ASC
LIMIT 20
$$) as (
    friendId bigint,
    friendFirstName varchar,
    friendLastName varchar,
    ct1 bigint,
    ct2 bigint,
    total bigint
);