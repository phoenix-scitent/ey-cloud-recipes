define :postgresql9_fuzzystrmatch do
 dbname_to_use = params[:name]  
 
  load_sql_file do 
    db_name dbname_to_use
    filename "/usr/share/postgresql-9.0/contrib/fuzzystrmatch.sql"
  end

end