;extends
;go_6
((call_expression
(selector_expression
field: (field_identifier) @_field)
(argument_list
(interpreted_string_literal) @sql))
(#any-of? @_field "Exec" "GetContext" "ExecContext" "SelectContext" "In"
"RebindNamed" "Rebind" "Query" "QueryRow" "QueryRowxContext" "NamedExec" "MustExec" "Get" "Queryx")
(#offset! @sql 0 1 0 -1))

;stillbuggyfornvim010
((call_expression
(selector_expression
field: (field_identifier) @_field (#any-of? @_field "Exec" "GetContext" "ExecContext" "SelectContext" "In" "RebindNamed" "Rebind" "Query" "QueryRow" "QueryRowxContext" "NamedExec" "MustExec" "Get" "Queryx"))
(argument_list
(interpreted_string_literal) @injection.content))
(#offset! @injection.content 0 1 0 -1)
(#set! injection.language "sql"))

;neovimnightly010
([
(interpreted_string_literal)
(raw_string_literal)
] @injection.content
(#match? @injection.content "(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete).+(FROM|from|INTO|into|VALUES|values|SET|set).*(WHERE|where|GROUP BY|group by)?")
(#set! injection.language "sql"))

;ageneralqueryinjection
([
(interpreted_string_literal)
(raw_string_literal)
] @sql
(#match? @sql "(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete).+(FROM|from|INTO|into|VALUES|values|SET|set).*(WHERE|where|GROUP BY|group by)?")
(#offset! @sql 0 1 0 -1))

;go_11
([
(interpreted_string_literal)
(raw_string_literal)
] @sql
(#contains? @sql "-- sql" "--sql" "ADD CONSTRAINT" "ALTER TABLE" "ALTER COLUMN"
"DATABASE" "FOREIGN KEY" "GROUP BY" "HAVING" "CREATE INDEX" "INSERT INTO"
"NOT NULL" "PRIMARY KEY" "UPDATE SET" "TRUNCATE TABLE" "LEFT JOIN" "add constraint" "alter table" "alter column" "database" "foreign key" "group by" "having" "create index" "insert into"
"not null" "primary key" "update set" "truncate table" "left join")
(#offset! @sql 0 1 0 -1))

;go_15
((const_spec
name: (identifier) @_const
value: (expression_list (raw_string_literal) @json))
(#lua-match? @_const ".*[J|j]son.*"))

;go_17
((short_var_declaration
left: (expression_list
(identifier) @_var)
right: (expression_list
(raw_string_literal) @json))
(#lua-match? @_var ".*[J|j]son.*")
(#offset! @json 0 1 0 -1))

;json_1
(const_spec
name: ((identifier) @_const(#lua-match? @_const ".*[J|j]son.*"))
value: (expression_list (raw_string_literal) @injection.content
(#set! injection.language "json")))

;json_2
(short_var_declaration
left: (expression_list (identifier) @_var (#lua-match? @_var ".*[J|j]son.*"))
right: (expression_list (raw_string_literal) @injection.content)
(#offset! @injection.content 0 1 0 -1)
(#set! injection.language "json"))

;json_3
(var_spec
name: ((identifier) @_const(#lua-match? @_const ".*[J|j]son.*"))
value: (expression_list (raw_string_literal) @injection.content
(#set! injection.language "json")))

