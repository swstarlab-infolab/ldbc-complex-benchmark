create extension pg_graph;
-------------------------------
-------- create vertex --------
-------------------------------
select create_vertex('tagclass', '{"tc_issubclassof_tc"}', '{"tc_issubclassof_tc", "tag_hastype_tc"}', 'tagclass_prop', 'physical'); 
select create_vertex('tag', '{"tag_hastype_tc"}', '{"person_hasinterest_tag", "forum_hastag_tag", "message_hastag_tag"}', 'tag_prop', 'physical'); 
select create_vertex('city', '{"city_ispartof_country"}', '{"person_islocatedin_city"}', 'city_prop', 'physical'); 
select create_vertex('country', '{"country_ispartof_continent"}', '{"city_ispartof_country"}', 'country_prop', 'physical'); 
select create_vertex('continent', NULL, '{"country_ispartof_continent"}', 'continent_prop', 'physical'); 
select create_vertex('university', NULL, '{"person_studyat_university"}', 'university_prop', 'physical'); 
select create_vertex('company', NULL, '{"person_workat_company"}', 'company_prop', 'physical');

select create_vertex('person', '{"person_hasinterest_tag", "person_islocatedin_city", "person_studyat_university", "person_workat_company", "person_likes_message", "person_knows_person"}', '{"person_knows_person", "forum_hasmember_person", "forum_hasmoderator_person", "message_hascreator_person"}', 'person_prop', 'physical'); 
select create_vertex('forum', '{"forum_hasmember_person", "forum_hasmoderator_person", "forum_hastag_tag", "forum_containerof_message"}', NULL, 'forum_prop', 'physical'); 
select create_vertex('message', '{"message_hascreator_person", "message_hastag_tag", "message_replyof_message"}', '{"person_likes_message", "forum_containerof_message", "message_replyof_message"}', 'message_prop', 'physical'); 

-------------------------------
--------- create edge ---------
-------------------------------
select create_edge('tc_issubclassof_tc', 'tagclass', 'tagclass', 'tc_issubclassof_tc_prop', 'discrete', 'physical', 'prop');
select create_edge('tag_hastype_tc', 'tag', 'tagclass', 'tag_hastype_tc_prop', 'discrete', 'physical', 'prop');
select create_edge('city_ispartof_country', 'city', 'country', 'city_ispartof_country_prop', 'discrete', 'physical', 'prop');
select create_edge('country_ispartof_continent', 'country', 'continent', 'country_ispartof_continent_prop', 'discrete', 'physical', 'prop');

select create_edge('person_hasinterest_tag', 'person', 'tag', 'person_hasinterest_tag_prop', 'discrete', 'physical', 'prop');
select create_edge('person_islocatedin_city', 'person', 'city', 'person_islocatedin_city_prop', 'discrete', 'physical', 'prop');
select create_edge('person_studyat_university', 'person', 'university', 'person_studyat_university_prop', 'discrete', 'physical', 'prop');
select create_edge('person_workat_company', 'person', 'company', 'person_workat_company_prop', 'discrete', 'physical', 'prop');
select create_edge('person_likes_message', 'person', 'message', 'person_likes_message_prop', 'discrete', 'physical', 'prop');
select create_edge('person_knows_person', 'person', 'person', 'person_knows_person_prop', 'discrete', 'physical', 'prop');

select create_edge('forum_hasmember_person', 'forum', 'person', 'forum_hasmember_person_prop', 'discrete', 'physical', 'prop');
select create_edge('forum_hasmoderator_person', 'forum', 'person', 'forum_hasmoderator_person_prop', 'discrete', 'physical', 'prop');
select create_edge('forum_hastag_tag', 'forum', 'tag', 'forum_hastag_tag_prop', 'discrete', 'physical', 'prop');
select create_edge('forum_containerof_message', 'forum', 'message', 'forum_containerof_message_prop', 'discrete', 'physical', 'prop');

select create_edge('message_hascreator_person', 'message', 'person', 'message_hascreator_person_prop', 'discrete', 'physical', 'dst');
select create_edge('message_hastag_tag', 'message', 'tag', 'message_hastag_tag_prop', 'discrete', 'physical', 'prop');
select create_edge('message_replyof_message', 'message', 'message', 'message_replyof_message_prop', 'discrete', 'physical', 'prop');