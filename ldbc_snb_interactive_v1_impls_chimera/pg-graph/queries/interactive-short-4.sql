/* IS4. Content of a message
\set messageId 206158431836
 */
SELECT messageContent, messageCreationDate FROM cypher($$
MATCH (m:message)
WHERE m.vertex_id = :messageId
RETURN
    coalesce(m.content, m.imagefile) as messageContent,
    m.creationdate as messageCreationDate
$$) as (messageContent text, messageCreationDate timestamp);