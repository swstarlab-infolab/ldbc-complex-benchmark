/* Q2. Recent messages by your friends
\set personId 10995116278009
\set maxDate '\'2010-10-16\''
 */
SELECT personId,
    personFirstName,
    personLastName,
    postOrCommentId,
    postOrCommentContent,
    postOrCommentCreationDate
FROM cypher($$
MATCH (p:person)-[:person_knows_person]->(f:person)<-[:message_hascreator_person]-(m:message)
WHERE p.vertex_id = :personId AND m.creationdate < :maxDate
RETURN
    f.vertex_id AS personId,
    f.firstname AS personFirstName,
    f.lastname AS personLastName,
    m.vertex_id AS postOrCommentId,
    coalesce(m.content, m.imagefile) AS postOrCommentContent,
    m.creationdate AS postOrCommentCreationDate
ORDER BY
    m.creationdate DESC,
    m.vertex_id ASC
LIMIT 20
$$) as (
    personId bigint,
    personFirstName varchar,
    personLastName varchar,
    postOrCommentId bigint,
    postOrCommentContent text,
    postOrCommentCreationDate timestamp
);
