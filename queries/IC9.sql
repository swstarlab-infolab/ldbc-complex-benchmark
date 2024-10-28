/* Q9. Recent messages by friends or friends of friends
\set personId 933
\set maxDate '2010-10-01'
 */
select p_personid, p_firstname, p_lastname,
       m_messageid, m_content, m_creationdate
from cypher($$
MATCH (p:person)-[:person_knows_person]->(f:person)<-[:message_hascreator_person]-(m:message)
WHERE p.vertex_id = 26388279803831
AND m.creationdate < to_timestamp(1335225600)
RETURN
    f.vertex_id AS p_personid,
    f.firstname AS p_firstname,
    f.lastname AS p_lastname,
    m.vertex_id AS m_messageid,
    m.content AS m_content,
    m.creationdate AS m_creationdate
ORDER BY
    m.creationdate DESC,
    m.vertex_id ASC
LIMIT 20
$$) as (
    p_personid bigint,
    p_firstname varchar,
    p_lastname varchar,
    m_messageid bigint,
    m_content varchar,
    m_creationdate timestamp
);
