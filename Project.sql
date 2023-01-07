set serveroutput on 
declare 
        -- cursor to get table name and  the primary key column name for every table name  
      cursor dept_cursor is 
              select ut.table_name , uc.column_name  from user_tab_columns ut
               join USER_CONS_COLUMNS uc on uc.table_name  = ut.table_name and ut.column_name = uc.column_name
               join user_constraints ucc on ucc.table_name = uc.table_name and ucc.constraint_name = uc.constraint_name
               where ucc.constraint_type = 'P'  and ut.data_type = 'NUMBER' ;
      
                x_max number(6);
begin    
        -- this is a procedure to drop any seq or triggers existis for the table 
         drop_seq ;
 

        -- here we begin to create new sequence and trigger for  every table
        for dept_record in dept_cursor loop
                -- getting max value for the primary key + 1 
                execute immediate  'select (max('|| dept_record.column_name||')+1) from '||dept_record.table_name into x_max ;
             -- dbms_output.put_line(x_max);
            
                -- create seq
                execute immediate  'CREATE SEQUENCE '||dept_record.table_name || '_seq  
                START WITH '||x_max ||
                 ' increment by 1
                 MAXVALUE 9999999999999';
                
                -- create trigger 
                 execute immediate 'Create or replace trigger '||dept_record.table_name || '_trg
                 BEFORE INSERT ON '||dept_record.table_name ||  '
                  FOR EACH ROW
                  BEGIN
                :new.'|| dept_record.column_name ||' := '||dept_record.table_name ||'_seq.nextval;
                 END;' ;
        end  loop;       
                 
end ;

show errors;

insert into departments ( DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
values ('sdsd',108,1700)








