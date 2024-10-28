/* Q5 New groups
\set personId 933
\set minDate '2010-10-01'
 */
SELECT forumName, postCount
FROM cypher($$
MATCH (p:person)-[:person_knows_person]->(op:person),
    (op)<-[membership:forum_hasmember_person]-(f:forum),
    (post:message)<-[:forum_containerof_message]-(f)
WHERE p.vertex_id = 32985349836349
AND p.vertex_id <> op.vertex_id
AND membership.joindate > to_timestamp(1344643200)
RETURN
    f.vertex_id AS forumId,
    f.title AS forumName,
    count(post) AS postCount
ORDER BY
    count(post) DESC,
    f.vertex_id ASC
LIMIT 20
$$) as (forumId bigint, forumName varchar, postCount bigint);
