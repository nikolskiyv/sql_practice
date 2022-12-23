select
    id
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
      start with z.ID = v.ID
    ) as total_size
from
  file_system v
where
  type = 'DIR'
connect by
  parent_id = prior id
start with
  parent_id is null
order by NAME;
