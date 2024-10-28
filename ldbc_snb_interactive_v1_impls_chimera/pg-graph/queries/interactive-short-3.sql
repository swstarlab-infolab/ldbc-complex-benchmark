/* IS3. Friends of a person
\set personId 10995116277794
 */
SELECT personId, firstName, lastName, friendshipCreationDate FROM cypher($$
MATCH (n:person)-[r:person_knows_person]->(friend:person)
WHERE n.vertex_id = :personId
RETURN
    friend.vertex_id AS personId,
    friend.firstname AS firstName,
    friend.lastname AS lastName,
    r.creationdate AS friendshipCreationDate
ORDER BY
    r.creationdate DESC,
    friend.vertex_id ASC
$$) as (personId bigint, firstName varchar, lastName varchar, friendshipCreationDate timestamp);
