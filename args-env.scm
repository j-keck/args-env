(module args-env

    (args-env:parse
     args-env:from-env

     ;; re-export from 'args'
     args:parse
     args:help-options
     args:ignore-unrecognized-options
     args:accept-unrecognized-options
     make-args:option
     args:usage
     args:width
     args:separator
     args:indent
     args:make-option)


  (import scheme chicken data-structures)
  (use srfi-1 srfi-13 args)
  (use (only srfi-37 option-names))
  (use (only posix get-environment-variables))



  ;; parse args from command line and environment-variables
  ;;
  ;; it uses 'args:parse' to parse the command line arguments
  ;; and adds the arguments defined as environment-variables
  ;; at the end of the options.
  (define (args-env:parse args options-list . optionals)
    (let ([from-env  (args-env:from-env options-list)])
      (receive (options operands) (args:parse args options-list optionals)
        (values (append options from-env) operands))))



  ;; extracts the args from environment-variables and returns it
  ;; as an alist like 'args:parse'.
  (define (args-env:from-env opts)

    (define env (get-environment-variables))

    (define (lookup-from-env arg-name)
      (let ([env-name (string-upcase (string-translate arg-name "-" "_"))])
        (alist-ref env-name env string=?)))

      (define (lookup names)
      (let ([value (filter-map lookup-from-env names)])
        (if (null? value)
            '()
            (map (lambda(n) `(,(string->symbol n) . ,(car value))) names))))

    (concatenate (map lookup (long-option-names opts))))




  ;; extracts all long-option-names from the given opts list
  ;; where 'opts' is a list of records of 'args:option'
  (define (long-option-names opts)

    ;; this record has the same signature as the 'args:option' record from 'args'.
    ;; because 'args' doesn't export any functions to access the slots,
    ;; i use this wrapper to extract the srfi-37 'option' slot.
    (define-record-type args:option
      (_ option arg-name docstring)
      _?
      (option option-from-args))


    (define (long-option-names-from-args arg)
      (let ([option-names (option-names (option-from-args arg))])
        (filter (compose not char?) option-names)))

    (map long-option-names-from-args opts))
  )
