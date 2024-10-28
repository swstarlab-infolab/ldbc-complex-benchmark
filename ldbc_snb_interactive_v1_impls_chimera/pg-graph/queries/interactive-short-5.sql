/* IS5. Creator of a message
\set messageId 206158431836
 */
SELECT personId, firstName, lastName FROM cypher($$
MATCH (m:message)-[:message_hascreator_person]->(p:person)
WHERE m.vertex_id = :messageId
RETURN
    p.vertex_id AS personId,
    p.firstname AS firstName,
    p.lastname AS lastName
$$) as (personId bigint, firstName varchar, lastName varchar);