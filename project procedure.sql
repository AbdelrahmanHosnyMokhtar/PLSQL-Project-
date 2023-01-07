set serveroutput on 
-- this is a procedure to drop any seq created by the user that has a name as the same name of the table 
create or replace procedure drop_seq 
is 
  cursor dept_cursor is 
              select distinct(table_name)  from user_tab_columns 
              where  table_name  
              in   ( select object_name from user_objects  where object_type = 'TABLE') ;
      
   cursor seq_name is 
               select sequence_name from user_sequences ; 

begin 
        for seq_rec in seq_name loop
                 for dept_rec in dept_cursor loop
                        if seq_rec.sequence_name like substr(dept_rec.table_name,1,4)||'%' then 
                              execute immediate 'drop sequence '|| seq_rec.sequence_name ;
                       end if;
               end loop;
        end loop;    

end;
show errors;


-- this is a procedure to drop any trigger created by the user that has a name as the same name of the table 
create or replace procedure drop_trigger
is 
  cursor dept_cursor is 
              select distinct(table_name)  from user_tab_columns 
              where  table_name  
              in   ( select object_name from user_objects  where object_type = 'TABLE') ;
      
   cursor trg_name is 
               select object_name from user_objects where  object_type='TRIGGER' ; 

begin 
        for trg_rec in trg_name loop
                 for dept_rec in dept_cursor loop
                        if trg_rec.object_name like substr(dept_rec.table_name,1,5)||'%' then 
                              execute immediate 'drop trigger '|| trg_rec.object_name ;
                       end if;
               end loop;
        end loop;    

end;









