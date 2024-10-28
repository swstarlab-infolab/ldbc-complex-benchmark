/* Q8. Recent replies
\set personId 143
 */
SELECT personId, personFirstName, personLastName, commentCreationDate, 
        commentId, commentContent
FROM cypher($$
MATCH (start:person)<-[:message_hascreator_person]-(:message)<-[:message_replyof_message]-(comment:message)-[:message_hascreator_person]->(dest:person)
WHERE start.vertex_id = :personId
RETURN
    dest.vertex_id AS personId,
    dest.firstname AS personFirstName,
    dest.lastname AS personLastName,
    comment.creationdate AS commentCreationDate,
    comment.vertex_id AS commentId,
    comment.content AS commentContent
ORDER BY
    comment.creationdate DESC,
    comment.vertex_id ASC
LIMIT 20
$$) as (personId bigint, personFirstName varchar, personLastName varchar, commentCreationDate timestamp, 
        commentId bigint, commentContent text);
