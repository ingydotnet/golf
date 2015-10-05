(require 'pegex').require 'tree'

(global.Golf?={})
class Golf.AST extends Pegex.Tree
  got_block_comment: (got)->
    type: 'comment'
    value: got
    block: true

  got_line_comment: (got)->
    type: 'comment'
    value: got
    block: false

  got_other: (got)->
    type: 'other'
    value: got
