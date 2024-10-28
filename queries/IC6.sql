/* Q6. Tag co-occurrence
\set personId 933
\set tagName 'Hamid_Karzai'
 */
select tagName, postCount
from cypher($$
MATCH (p:person)-[:person_knows_person]->(op:person)<-[:message_hascreator_person]-(ps:message),
      (ps)-[ht1:message_hastag_tag]->(t:tag),
      (ps)-[ht2:message_hastag_tag]->(t2:tag)
WHERE p.vertex_id = 2560680
AND t.name = 'John_Layfield'
AND t2.name <> 'John_Layfield'
RETURN
    t2.name AS tagName,
    count(ps) AS postCount
ORDER BY
    count(ps) DESC,
    t2.name ASC
LIMIT 10
$$) as (tagName varchar, postCount bigint);