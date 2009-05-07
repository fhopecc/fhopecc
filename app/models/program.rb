class EltPatch < ActiveRecord::Base
  establish_connection "eltweb" 

  set_table_name 'audit_trails'
end

