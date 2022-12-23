with table_1 as (
  select
      id
    , parent_id
    , name
    , sys_connect_by_path(name, '/') as path
    , (
	    select
          SUM(file_size)
        from
          file_system z
        where
          type = 'FILE'
        connect by
          parent_id = prior id
        start with z.id = v.id
        ) as total_size
from
  file_system v
where
  type = 'DIR'
connect by
  parent_id = prior id
start with
  parent_id is null
)

select
    id
  , parent_id
  , name
  , path
  , total_size, ratio_to_report(total_size) over (partition by parent_id) as ratio from table_1
order by name;
