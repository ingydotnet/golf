#!/usr/bin/env coffee

say = console.log
xxx = ->
    say yaml.dump Array.prototype.slice.call arguments
    process.exit 1

{pegex} = require 'pegex'
fs = require 'fs'
yaml = require 'js-yaml'

text = String fs.readFileSync 'share/golf.pgx'

parser = pegex text
grammar = parser.grammar
grammar.make_tree()
parser.debug = true
console.log yaml.dump grammar.tree

golf = """\
###
This is a multi-line block comment
Wahoo!
###

package main

# This is a single line comment

func main() {
    var a int   # A variable definition
}

"""

xxx parser.parse golf

# test "Pegex.pegex export function works", ->
#   tree = pegex('a: /(b)/').parse 'b'
#   deepEqual tree, a: 'b'

