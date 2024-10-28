-- \set personId 1829
-- \set commentId 1924147579404
-- \set creationDate '\'2023-06-05\''::date

WITH prop_inserted AS (
    insert into person_likes_message_prop (
      src_vertex_id,
      dst_vertex_id,
      creationdate
    )
    values
    (
      :personId, 
      :commentId, 
      :creationDate
    )
    returning ctid as prop_ptr
)
select insert_edge_physical(
    'person_likes_message', 
    'person', 
    'message', 
    :personId, 
    :commentId, 
    (select prop_ptr from prop_inserted)
);