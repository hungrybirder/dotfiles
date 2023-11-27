;extends
;css_variables
        (assignment
            ((identifier) @_varx (#match? @_varx ".*css$"))
            (string
                (string_content) @injection.content (#set! injection.language "css"))) 
      
;html_variables
        (assignment
            ((identifier) @_varx (#match? @_varx ".*html$"))
            (string
                (string_content) @injection.content (#set! injection.language "html"))) 
      
;javascript_variables
        (assignment
            ((identifier) @_varx (#match? @_varx ".*js$"))
            (string
                (string_content) @injection.content (#set! injection.language "javascript"))) 
      
;loads_attribute_json
        (call
          function: (attribute
              attribute: (identifier) @_idd (#eq? @_idd "loads"))
          arguments: (argument_list
            (string (string_content) @injection.content (#set! injection.language "json") ) ) )
      
;rst_for_docstring
      (function_definition
        (block
          (expression_statement
            (string
                (string_content) @injection.content (#set! injection.language "rst")))))
      
;style_attribute_css
        (call
          function: (attribute
              attribute: (identifier) @_idd (#eq? @_idd "style"))
          arguments: (argument_list
            (string (string_content) @injection.content (#set! injection.language "css")))) 
      
