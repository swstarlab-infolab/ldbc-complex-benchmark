-- \set forumId 1829
-- \set personId 1924147579404
-- \set joinDate '\'2023-06-05\''::date

WITH prop_inserted AS (
    insert into forum_hasmember_person_prop (
      src_vertex_id,
      dst_vertex_id,
      joindate
    )
    values
    (
      :forumId, 
      :personId, 
      :joinDate
    )
    returning ctid as prop_ptr
)
select insert_edge_physical(
    'forum_hasmember_person', 
    'forum', 
    'person', 
    :forumId, 
    :personId, 
    (select prop_ptr from prop_inserted)
);