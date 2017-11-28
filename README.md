# args-env

program arguments per command-line or environment variables - on top of **args**.


## Description

This simple chicken-egg wraps [args](http://wiki.call-cc.org/eggref/4/args) to
support options from environment-variables.

It re-exports all functions from **args** - so you use it as you would use **args**.
To parse the options, use the **args-env:parse** function to receive the options
from the command-line and environment-variables.


## Example:

```scheme
;;
;; simple example how to use 'args-env'.
;;
;; with 'args-env' you can define you program arguments:
;;
;;  - per command-line:
;;      > csi -s args-env-example.scm --example-option from-cmd-line
;;      (example-option . from-cmd-line)
;;
;;
;;  - or environment-variables
;;       > EXAMPLE_OPTION=from-env csi -s args-env-example.scm
;;       (example-option . from-env)
;;
;;
;;  - if the argument is given per cmd-line and in the environment,
;;    the value from the cmd-line are used
;;       > EXAMPLE_OPTION=from-env csi -s args-env-example.scm --example-option from-cmd-line
;;       (example-option . from-cmd-line)
;;
;;
(use args-env)

;; use 'args:make-option' from 'args' to define your options
(define opts
  (list (args:make-option (example-option) #:required "example")))


;; instead of 'args:parse' use 'args-env:parse' to parse the options
(print (assq 'example-option (args-env:parse (command-line-arguments) opts)))
```
_args-env-example.scm_

