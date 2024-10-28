/* Q4. New topics
\set personId 10995116277918
\set startDate '\'2010-10-01\''::date
\set durationDays 31
 */
SELECT tagName, postCount
FROM cypher($$
MATCH (p:person)-[:person_knows_person]->(f:person),
      (f)<-[:message_hascreator_person]-(post:message)-[:message_hastag_tag]->(t:tag)
WHERE p.vertex_id = :personId
AND post.creationdate >= :startDate
AND post.creationdate < (:startDate::timestamp + :durationDays * '1 days'::interval) 
WITH DISTINCT t.name AS tagName, post.vertex_id as postId
WITH tagName, count(postId) AS postCount
RETURN tagName, postCount
ORDER BY postCount DESC, tagName ASC
LIMIT 10
$$) as (tagName varchar, postCount bigint);