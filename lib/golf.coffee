fs = require 'fs'

class global.Golf
  run: (args)->
    @get_opts args
    if @args.compile
      @compile_golf()
      @emit_ast_to_go()
      @write_output()
    else
      throw 'Currently requires --compile option'

  get_opts: (args)->
    argparse = require 'argparse'
    ArgumentParser = argparse.ArgumentParser
    parser = new ArgumentParser
      prog: 'golf'
      version: 'golf - version 0.0.1'
      addHelp: true
      description: 'The Golf language compiler.'
      epilog: 'If called without options, `golf` will run your program.'
    parser.addArgument \
      [ '-c', '--compile' ],
      action: 'storeTrue'
      help: 'Compile to Go and save as .go files.'
    parser.addArgument \
      [ '-e', '--eval' ],
      action: 'append'
      metavar: '<str>'
      help: 'Pass a string from the command line as input.'
    parser.addArgument \
      [ '-p', '--print' ],
      action: 'storeTrue'
      help: 'Print the compiled Go to stdout.'
    parser.addArgument \
      [ 'path/to/file.golf' ],
      nargs: '?'
      help: 'The Golf program.'
    parser.addArgument \
      [ '<program arguments>' ],
      nargs: '...'
      help: "The Golf program's arguments."
    @args = parser.parseArgs(args)

  compile_golf: ->
    require './golf/ast'
    (require 'pegex').require 'parser', 'grammar'

    grammar_text = String fs.readFileSync 'share/golf.pgx'

    parser = new Pegex.Parser
      grammar: new Pegex.Grammar text: grammar_text
      receiver: new Golf.AST

    @read_input()
    @ast = parser.parse @input_text

  emit_ast_to_go: ->
    @output_text = ''
    for node in @ast
      switch node.type
        when 'comment'
          if node.block
            @output_text += "/*#{node.value}*/"
          else
            @output_text += "//#{node.value}\n"
        when 'other'
            @output_text += node.value

  read_input: ->
    if @args.eval?
      @input_text = ''
      for line in @args.eval
        @input_text += line + "\n"
      return
    @input_file = @args['path/to/file.golf']
    if @input_file?
      if @input_file.match /\.golf$/
        @output_file = @input_file.replace(/\.golf$/, '.go')
      @input_text = String fs.readFileSync @input_file
    else
      @input_text = fs.readFileSync('/dev/stdin').toString()

  write_output: ->
    if @args.print or not @input_file?
      fs.writeSync 1, @output_text
    else
      if @output_file?
        fs.writeFileSync @output_file, @output_text
      else
        throw "Input file does not end with '.golf'. Try --print for output."

# vim: set sw=2:
