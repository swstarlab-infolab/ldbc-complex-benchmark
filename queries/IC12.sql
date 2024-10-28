/* Q12. Expert search
\set personId 933
 */
SELECT personId,
    personFirstName,
    personLastName,
    '{tagNames}'::varchar[] AS tagNames,
    count(distinct commentId) as replyCount
FROM cypher($$
MATCH (p:person)-[:person_knows_person]->(friend:person)<-[:message_hascreator_person]-(comment:message)-[:message_replyof_message]->(:message)-[:message_hastag_tag]->(t2:tag)
WHERE p.vertex_id = 8796093917072
RETURN
    friend.vertex_id AS personId,
    friend.firstname AS personFirstName,
    friend.lastname AS personLastName,
    comment.vertex_id AS commentId
$$) as (
    personId bigint, 
    personFirstName varchar, 
    personLastName varchar, 
    commentId bigint
)
GROUP BY personId, personFirstName, personLastName
ORDER BY
    replyCount DESC,
    personId ASC
LIMIT 20;
