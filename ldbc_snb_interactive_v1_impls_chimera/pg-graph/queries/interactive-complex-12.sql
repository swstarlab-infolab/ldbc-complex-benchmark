/* Q12. Expert search
\set personId 10995116278009
\set tagClassName '\'Monarch\''
 */
SELECT personId,
    personFirstName,
    personLastName,
    tagNames,
    replyCount
FROM cypher($$
MATCH (p:person)-[:person_knows_person]->(friend:person)<-[:message_hascreator_person]-(comment:message)-[:message_replyof_message]->(:message)-[:message_hastag_tag]->(t2:tag)
WHERE p.vertex_id = :personId
RETURN
    friend.vertex_id AS personId,
    friend.firstname AS personFirstName,
    friend.lastname AS personLastName,
    '{tagNames}' AS tagNames,
    count(DISTINCT comment) AS replyCount
ORDER BY
    count(DISTINCT comment) DESC,
    friend.vertex_id ASC
LIMIT 20
$$) as (
    personId bigint, 
    personFirstName varchar, 
    personLastName varchar, 
    tagNames varchar[], 
    replyCount bigint
);