/* Q7. Recent likers
\set personId 933
 */
SELECT personId, 
    personFirstName, 
    personLastName, 
    likeCreationDate,
    commentOrPostId,
    commentOrPostContent,
    minutesLatency,
    isNew
FROM cypher($$
MATCH (p:person)<-[:message_hascreator_person]-(m:message)<-[like:person_likes_message]-(liker:person)
WHERE p.vertex_id = 21990233990031
WITH liker.vertex_id AS personId,
    liker.firstname AS personFirstName,
    liker.lastname AS personLastName, 
    m.vertex_id AS messageId, 
    like.creationdate AS likeTime
ORDER BY like.creationdate DESC, m.vertex_id ASC
WITH personId,
    personFirstName,
    personLastName, 
    array_agg({msg: messageId, lt: likeTime})[1] AS latestLike
RETURN
    personId,
    personFirstName,
    personLastName,
    json_object_field_text(latestLike, 'lt') AS likeCreationDate,
    json_object_field_text(latestLike, 'msg') AS commentOrPostId,
    'content' AS commentOrPostContent,
    0 AS minutesLatency,
    false AS isNew
ORDER BY
    json_object_field_text(latestLike, 'lt') DESC,
    personId ASC
LIMIT 20
$$) as (
    personId bigint, 
    personFirstName varchar, 
    personLastName varchar, 
    likeCreationDate timestamp,
    commentOrPostId bigint,
    commentOrPostContent text,
    minutesLatency integer,
    isNew boolean
);
