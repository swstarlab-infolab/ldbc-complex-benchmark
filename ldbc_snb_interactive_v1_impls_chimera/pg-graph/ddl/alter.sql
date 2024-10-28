-------------------------------
-------- static schema --------
-------------------------------

-- tc_issubclassof_tc
CREATE TABLE tc_issubclassof_tc_prop (
    edge_id bigserial PRIMARY KEY,
    src_vertex_id bigint,
    dst_vertex_id bigint
);
ALTER SEQUENCE tc_issubclassof_tc_prop_edge_id_seq
    NO MAXVALUE;
INSERT INTO tc_issubclassof_tc_prop (src_vertex_id, dst_vertex_id)
SELECT 
    tc_tagclassid as src_vertex_id,
    tc_subclassoftagclassid as dst_vertex_id
FROM tagclass;

-- tag_hastype_tc
CREATE TABLE tag_hastype_tc_prop (
    edge_id bigserial PRIMARY KEY,
    src_vertex_id bigint,
    dst_vertex_id bigint
);
ALTER SEQUENCE tag_hastype_tc_prop_edge_id_seq
    NO MAXVALUE;
INSERT INTO tag_hastype_tc_prop (src_vertex_id, dst_vertex_id)
SELECT
    t_tagid as src_vertex_id,
    t_tagclassid as dst_vertex_id
FROM tag;

-- city_ispartof_country
CREATE TABLE city_ispartof_country_prop (
    edge_id bigserial PRIMARY KEY,
    src_vertex_id bigint,
    dst_vertex_id bigint
);
ALTER SEQUENCE city_ispartof_country_prop_edge_id_seq
    NO MAXVALUE;
INSERT INTO city_ispartof_country_prop (src_vertex_id, dst_vertex_id)
SELECT
    pl_placeid as src_vertex_id,
    pl_containerplaceid as dst_vertex_id
FROM place
WHERE pl_type = 'city';

-- country_ispartof_continent
CREATE TABLE country_ispartof_continent_prop (
    edge_id bigserial PRIMARY KEY,
    src_vertex_id bigint,
    dst_vertex_id bigint
);
ALTER SEQUENCE country_ispartof_continent_prop_edge_id_seq
    NO MAXVALUE;
INSERT INTO country_ispartof_continent_prop (src_vertex_id, dst_vertex_id)
SELECT
    pl_placeid as src_vertex_id,
    pl_containerplaceid as dst_vertex_id
FROM place
WHERE pl_type = 'country';


-------------------------------
------- dynamic schema --------
-------------------------------

-- person_hasinterest_tag
ALTER TABLE person_tag
DROP CONSTRAINT person_tag_pkey;
ALTER TABLE person_tag
RENAME TO person_hasinterest_tag_prop;
ALTER TABLE person_hasinterest_tag_prop
ADD COLUMN edge_id bigserial PRIMARY KEY;
ALTER SEQUENCE person_hasinterest_tag_prop_edge_id_seq
    NO MAXVALUE;
ALTER TABLE person_hasinterest_tag_prop
RENAME pt_personid TO src_vertex_id;
ALTER TABLE person_hasinterest_tag_prop
RENAME pt_tagid TO dst_vertex_id;

-- person_islocatedin_city
CREATE TABLE person_islocatedin_city_prop (
    edge_id bigserial PRIMARY KEY,
    src_vertex_id bigint,
    dst_vertex_id bigint
);
ALTER SEQUENCE person_islocatedin_city_prop_edge_id_seq
    NO MAXVALUE;
INSERT INTO person_islocatedin_city_prop (src_vertex_id, dst_vertex_id)
SELECT
    p_personid as src_vertex_id,
    p_placeid as dst_vertex_id
FROM person;

-- person_studyat_university
ALTER TABLE person_university
DROP CONSTRAINT person_university_pkey;
ALTER TABLE person_university
RENAME TO person_studyat_university_prop;
ALTER TABLE person_studyat_university_prop
ADD COLUMN edge_id bigserial PRIMARY KEY;
ALTER SEQUENCE person_studyat_university_prop_edge_id_seq
    NO MAXVALUE;
ALTER TABLE person_studyat_university_prop
RENAME pu_personid TO src_vertex_id;
ALTER TABLE person_studyat_university_prop
RENAME pu_organisationid TO dst_vertex_id;
ALTER TABLE person_studyat_university_prop
RENAME pu_classyear TO classyear;

-- person_workat_company
ALTER TABLE person_company
DROP CONSTRAINT person_company_pkey;
ALTER TABLE person_company
RENAME TO person_workat_company_prop;
ALTER TABLE person_workat_company_prop
ADD COLUMN edge_id bigserial PRIMARY KEY;
ALTER SEQUENCE person_workat_company_prop_edge_id_seq
    NO MAXVALUE;
ALTER TABLE person_workat_company_prop
RENAME pc_personid TO src_vertex_id;
ALTER TABLE person_workat_company_prop
RENAME pc_organisationid TO dst_vertex_id;
ALTER TABLE person_workat_company_prop
RENAME pc_workfrom TO workfrom;

-- person_likes_message
ALTER TABLE likes
DROP CONSTRAINT likes_pkey;
ALTER TABLE likes
RENAME TO person_likes_message_prop;
ALTER TABLE person_likes_message_prop
ADD COLUMN edge_id bigserial PRIMARY KEY;
ALTER SEQUENCE person_likes_message_prop_edge_id_seq
    NO MAXVALUE;
ALTER TABLE person_likes_message_prop
RENAME l_personid TO src_vertex_id;
ALTER TABLE person_likes_message_prop
RENAME l_messageid TO dst_vertex_id;
ALTER TABLE person_likes_message_prop
RENAME l_creationdate TO creationdate;

-- person_knows_person
ALTER TABLE knows
DROP CONSTRAINT knows_pkey;
ALTER TABLE knows
RENAME TO person_knows_person_prop;
ALTER TABLE person_knows_person_prop
ADD COLUMN edge_id bigserial PRIMARY KEY;
ALTER SEQUENCE person_knows_person_prop_edge_id_seq
    NO MAXVALUE;
ALTER TABLE person_knows_person_prop
RENAME k_person1id TO src_vertex_id;
ALTER TABLE person_knows_person_prop
RENAME k_person2id TO dst_vertex_id;
ALTER TABLE person_knows_person_prop
RENAME k_creationdate TO creationdate;

-- forum_hastag_tag
ALTER TABLE forum_tag
DROP CONSTRAINT forum_tag_pkey;
ALTER TABLE forum_tag
RENAME TO forum_hastag_tag_prop;
ALTER TABLE forum_hastag_tag_prop
ADD COLUMN edge_id bigserial PRIMARY KEY;
ALTER SEQUENCE forum_hastag_tag_prop_edge_id_seq
    NO MAXVALUE;
ALTER TABLE forum_hastag_tag_prop
RENAME ft_forumid TO src_vertex_id;
ALTER TABLE forum_hastag_tag_prop
RENAME ft_tagid TO dst_vertex_id;

-- forum_hasmember_person
ALTER TABLE forum_person
DROP CONSTRAINT forum_person_pkey;
ALTER TABLE forum_person
RENAME TO forum_hasmember_person_prop;
ALTER TABLE forum_hasmember_person_prop
ADD COLUMN edge_id bigserial PRIMARY KEY;
ALTER SEQUENCE forum_hasmember_person_prop_edge_id_seq
    NO MAXVALUE;
ALTER TABLE forum_hasmember_person_prop
RENAME fp_forumid TO src_vertex_id;
ALTER TABLE forum_hasmember_person_prop
RENAME fp_personid TO dst_vertex_id;
ALTER TABLE forum_hasmember_person_prop
RENAME fp_joindate TO joindate;

-- forum_hasmoderator_person
CREATE TABLE forum_hasmoderator_person_prop (
    edge_id bigserial PRIMARY KEY,
    src_vertex_id bigint,
    dst_vertex_id bigint
);
ALTER SEQUENCE forum_hasmoderator_person_prop_edge_id_seq
    NO MAXVALUE;
INSERT INTO forum_hasmoderator_person_prop (src_vertex_id, dst_vertex_id)
SELECT
    f_forumid as src_vertex_id,
    f_moderatorid as dst_vertex_id
FROM forum;

-- forum_containerof_message
CREATE TABLE forum_containerof_message_prop (
    edge_id bigserial PRIMARY KEY,
    src_vertex_id bigint,
    dst_vertex_id bigint
);
ALTER SEQUENCE forum_containerof_message_prop_edge_id_seq
    NO MAXVALUE;
INSERT INTO forum_containerof_message_prop (src_vertex_id, dst_vertex_id)
SELECT
    m_ps_forumid as src_vertex_id,
    m_messageid as dst_vertex_id
FROM message
WHERE m_ps_forumid IS NOT NULL;

-- message_hascreator_person
CREATE TABLE message_hascreator_person_prop (
    edge_id bigserial PRIMARY KEY,
    src_vertex_id bigint,
    dst_vertex_id bigint
);
ALTER SEQUENCE message_hascreator_person_prop_edge_id_seq
    NO MAXVALUE;
INSERT INTO message_hascreator_person_prop (src_vertex_id, dst_vertex_id)
SELECT
    m_messageid as src_vertex_id,
    m_creatorid as dst_vertex_id
FROM message;

-- message_replyof_message
CREATE TABLE message_replyof_message_prop (
    edge_id bigserial PRIMARY KEY,
    src_vertex_id bigint,
    dst_vertex_id bigint
);
ALTER SEQUENCE message_replyof_message_prop_edge_id_seq
    NO MAXVALUE;
INSERT INTO message_replyof_message_prop (src_vertex_id, dst_vertex_id)
SELECT
    m_messageid as src_vertex_id,
    m_c_replyof as dst_vertex_id
FROM message
WHERE m_c_replyof IS NOT NULL;

-- message_hastag_tag
ALTER TABLE message_tag
DROP CONSTRAINT message_tag_pkey;
ALTER TABLE message_tag
RENAME TO message_hastag_tag_prop;
ALTER TABLE message_hastag_tag_prop
ADD COLUMN edge_id bigserial PRIMARY KEY;
ALTER SEQUENCE message_hastag_tag_prop_edge_id_seq
    NO MAXVALUE;
ALTER TABLE message_hastag_tag_prop
RENAME mt_messageid TO src_vertex_id;
ALTER TABLE message_hastag_tag_prop
RENAME mt_tagid TO dst_vertex_id;


-------------------------------
-------- static schema --------
-------------------------------

-- tagclass
ALTER TABLE tagclass
RENAME TO tagclass_prop;
ALTER TABLE tagclass_prop
RENAME tc_tagclassid TO vertex_id;
ALTER TABLE tagclass_prop
RENAME tc_name TO name;
ALTER TABLE tagclass_prop
RENAME tc_url TO url;
ALTER TABLE tagclass_prop
DROP COLUMN tc_subclassoftagclassid;

-- tag
ALTER TABLE tag
RENAME TO tag_prop;
ALTER TABLE tag_prop
RENAME t_tagid TO vertex_id;
ALTER TABLE tag_prop
RENAME t_name TO name;
ALTER TABLE tag_prop
RENAME t_url TO url;
ALTER TABLE tag_prop
DROP COLUMN t_tagclassid;

-- city
CREATE TABLE city_prop (
    vertex_id bigint PRIMARY KEY,
    name varchar,
    url varchar
);
INSERT INTO city_prop (vertex_id, name, url)
SELECT
    pl_placeid as vertex_id,
    pl_name as name,
    pl_url as url
FROM place
WHERE pl_type = 'city';

-- country
CREATE TABLE country_prop (
    vertex_id bigint PRIMARY KEY,
    name varchar,
    url varchar
);
INSERT INTO country_prop (vertex_id, name, url)
SELECT
    pl_placeid as vertex_id,
    pl_name as name,
    pl_url as url
FROM place
WHERE pl_type = 'country';

-- continent
CREATE TABLE continent_prop (
    vertex_id bigint PRIMARY KEY,
    name varchar,
    url varchar
);
INSERT INTO continent_prop (vertex_id, name, url)
SELECT
    pl_placeid as vertex_id,
    pl_name as name,
    pl_url as url
FROM place
WHERE pl_type = 'continent';

-- university
CREATE TABLE university_prop (
    vertex_id bigint PRIMARY KEY,
    name varchar,
    url varchar
);
INSERT INTO university_prop (vertex_id, name, url)
SELECT
    o_organisationid as vertex_id,
    o_name as name,
    o_url as url
FROM organisation
WHERE o_type = 'university';

-- company
CREATE TABLE company_prop (
    vertex_id bigint PRIMARY KEY,
    name varchar,
    url varchar
);
INSERT INTO company_prop (vertex_id, name, url)
SELECT
    o_organisationid as vertex_id,
    o_name as name,
    o_url as url
FROM organisation
WHERE o_type = 'company';


-------------------------------
------- dynamic schema --------
-------------------------------
ALTER TABLE person
RENAME TO person_prop;
ALTER TABLE person_prop
RENAME p_personid TO vertex_id;
ALTER TABLE person_prop
RENAME p_firstname TO firstname;
ALTER TABLE person_prop
RENAME p_lastname TO lastname;
ALTER TABLE person_prop
RENAME p_gender TO gender;
ALTER TABLE person_prop
RENAME p_birthday TO birthday;
ALTER TABLE person_prop
RENAME p_creationdate TO creationdate;
ALTER TABLE person_prop
RENAME p_locationip TO locationip;
ALTER TABLE person_prop
RENAME p_browserused TO browserused;
ALTER TABLE person_prop
DROP COLUMN p_placeid;


ALTER TABLE forum
RENAME TO forum_prop;
ALTER TABLE forum_prop
RENAME f_forumid TO vertex_id;
ALTER TABLE forum_prop
RENAME f_title TO title;
ALTER TABLE forum_prop
RENAME f_creationdate TO creationdate;
ALTER TABLE forum_prop
DROP COLUMN f_moderatorid;


ALTER TABLE message
RENAME TO message_prop;
ALTER TABLE message_prop
RENAME m_messageid TO vertex_id;
ALTER TABLE message_prop
RENAME m_creationdate TO creationdate;
ALTER TABLE message_prop
RENAME m_locationip TO locationip;
ALTER TABLE message_prop
RENAME m_browserused TO browserused;
ALTER TABLE message_prop
RENAME m_content TO content;
ALTER TABLE message_prop
RENAME m_length TO length;
ALTER TABLE message_prop
RENAME m_ps_language TO language;
ALTER TABLE message_prop
RENAME m_ps_imagefile TO imagefile;
ALTER TABLE message_prop
DROP COLUMN m_creatorid;
ALTER TABLE message_prop
DROP COLUMN m_locationid;
ALTER TABLE message_prop
DROP COLUMN m_ps_forumid;
ALTER TABLE message_prop
DROP COLUMN m_c_replyof;


-------------------------------
-------- static schema --------
-------------------------------
drop table place;
drop table country;
drop table organisation;

-------------------------------
------- dynamic schema --------
-------------------------------
drop table person_email;