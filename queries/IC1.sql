/* Q1. Transitive friends with certain name
\set personId 933
\set firstName 'Aleksei'
 */
SELECT friendId,
      friendLastName,
      distance,
      friendBirthday,
      friendCreationDate,
      friendGender,
      friendBrowserUsed,
      friendLocationIP,
      '{emails}'::varchar[] as emails,
      '{languages}'::varchar[] as languages,
      friendCityName,
      (select array_agg(ARRAY['o_name', 1::text, 'pl_name'])) as universities,
      (select array_agg(ARRAY['o_name', 1::text, 'pl_name'])) as companies
FROM cypher($$
MATCH (p1:person)-[:person_knows_person]->(p2:person)-[:person_islocatedin_city]->(c:city)
WHERE p1.vertex_id = 1173834
AND p2.firstname = 'John'
RETURN
    p2.vertex_id AS friendId,
    p2.lastname AS friendLastName,
    1 AS distance,
    p2.birthday AS friendBirthday,
    p2.creationdate AS friendCreationDate,
    p2.gender AS friendGender,
    p2.browserused AS friendBrowserUsed,
    p2.locationip AS friendLocationIP,
    c.name AS friendCityName
ORDER BY
    p2.lastname ASC,
    p2.vertex_id ASC
LIMIT 20
$$) as (
    friendId bigint,
    friendLastName varchar,
    distance bigint,
    friendBirthday date,
    friendCreationDate timestamp,
    friendGender varchar,
    friendBrowserUsed varchar,
    friendLocationIP varchar,
    friendCityName varchar
);