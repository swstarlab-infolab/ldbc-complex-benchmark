/* Q11. Job referral
\set personId 933
\set workFromYear 2011
 */
SELECT personId,
    personFirstName,
    personLastName,
    organizationName,
    organizationWorkFromYear
FROM cypher($$
MATCH (p:person)-[:person_knows_person]->(friend:person)
WHERE p.vertex_id = 28587303415817
    AND friend.vertex_id <> 28587303415817
WITH DISTINCT friend,
        friend.vertex_id AS personId,
        friend.firstname AS personFirstName,
        friend.lastname AS personLastName
MATCH (friend)-[workAt:person_workat_company]->(c:company)
WHERE workAt.workfrom < 2013
RETURN
        personId,
        personFirstName,
        personLastName,
        c.name AS organizationName,
        workAt.workfrom AS organizationWorkFromYear
ORDER BY
        workAt.workfrom ASC,
        personId ASC,
        c.name DESC
LIMIT 10
$$) as (
    personId bigint, 
    personFirstName varchar, 
    personLastName varchar, 
    organizationName varchar, 
    organizationWorkFromYear bigint
);