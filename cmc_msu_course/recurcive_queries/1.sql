select 
    id
  , name
  , sys_connect_by_path(name, '/') as paht
from
  file_system
where
  type = 'DIR'
    connect by
      parent_id = prior id
    start with
      parent_id is null
    order by NAME;
