
setClass('Grover',
         slots = list(
           host = 'character',
           port = 'numeric',
           auth = 'character'
         )
)

setClass('Repository',
         slots = list(
           path = 'character',
           files = 'character',
           extensions = 'character'
         ))