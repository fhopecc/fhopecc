class EltPatch < ActiveRecord::Base
  establish_connection "eltweb" 
  set_table_name 'ypmt010'
end

