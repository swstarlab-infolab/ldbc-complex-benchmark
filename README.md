# Chimera LDBC SNB demonstration

This repository provides a demonstration of query processing over LDBC SNB. 

## LDBC SNB

The Linked Data Benchmark Council’s Social Network Benchmark ([LDBC SNB](https://ldbcouncil.org/benchmarks/snb/)) is a *de-facto* standard benchmark for graph-like data management technologies.
LDBC SNB is designed to be a plausible look-alike of all the aspects of operating a social network site, as one of the most representative and relevant use cases of modern graph-like applications.


## Data model in Chimera

Graph-Relational DBMS, Chimera can have two data models, Graph and Relational.
The following shows the LDBC SNB dataset in two data models.

### 1. Graph data model
<p align="center">
<img src="https://github.com/swstarlab-infolab/ldbc-complex-benchmark/blob/master/img/Graph%20schema.png" width=80%>
</p>

### 2. Relational data model
<p align="center">
<img src="https://github.com/swstarlab-infolab/ldbc-complex-benchmark/blob/master/img/Relational%20schema.png" width=100%>
</p>


## Query in Chimera

Chimera can process graph queries on top of a graph data model and relational queries on top of a relational data model.
It supports SQL, which is the standard for relational queries, and [Cypher](https://opencypher.org/), which is the most popular for graph queries, for which there is no standard yet.
It can also support hybrid queries that mix Cypher and SQL like [SQL/PGQ](https://www.iso.org/standard/79473.html?browse=tc).
The query below shows the Interactive Complex 2 (IC2) query with Cypher that shows the top 20 most recent messages created by friends of a particular person.

```sql
/* IC2. Recent messages by your friends
\set personId 933
\set maxDate '2010-10-16'
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
```


## Client Interfaces in Chimera
Chimera is built on top of postgresql and supports all [postgresql-compatible client APIs](https://wiki.postgresql.org/wiki/List_of_drivers). 
The following shows a connection via the psql CLI as a representative example. 

<p align="center">
<img src="https://github.com/swstarlab-infolab/ldbc-complex-benchmark/blob/master/img/psql%20CLI.png" width=100%>
</p>


## Getting started
### 0. Requirements 

The recommended environment is that the benchmark scripts (Bash) and the LDBC driver (Java 8) run on the host machine, while the Chimera database runs in a Docker container. Therefore, the requirements are as follows:

* Bash
* Java 8
* Docker 19+
* postgresql-client


### 1. Setup

To clone a project with submodules, run: 

```bash
git clone --recurse-submodules git@github.com:swstarlab-infolab/ldbc-complex-benchmark.git
```

To install dependencies, run:

```bash
./setup/install_dependencies.sh
```


### 2. Loading the data
Setup scripts automatically loads dataset (for both graph and relational data models).
To load data with scale-factor 0.1 into the data-directory /mnt/disk1/ldbcsnb-demo, run

```bash
# loading for the first time
./scripts/setdb.sh init 0.1 /mnt/disk1/ldbcsnb-demo
# loaded previously 
./scripts/setdb.sh recycle 0.1 /mnt/disk1/ldbcsnb-demo
```

:warning: There should be enough space in the data-directory.


### 3. Querying the data
This demo supports IC2, IC4, IC8, IC12, IS1, IS3, IS4, and IS5 queries.
To run an IC2 query with psql, run: 

```bash
export PGPASSWORD=mysecretpassword
psql -h localhost -U postgres -d ldbcsnb -f queries/IC2.sql
```