{translate_sugar} = require './sugar'
{tokenize} = require './lexer'
{parse, Grammar} = require './parser'
{load} = require './generator'
fs = require 'fs'

exports.compile = compile = (code, options) ->
  [raw_tokens, comments] = tokenize code
  tokens = translate_sugar raw_tokens
  root_node = parse tokens, comments
  load Grammar
  return root_node.js()
  
if require.extensions
  require.extensions['.kal'] = (module, filename) ->
    content = compile fs.readFileSync(filename, 'utf8')
    module._compile content, filename
  
if not module.parent
  fs = require 'fs'
  assert = require 'assert'
  if process.argv[2] is '-c'
    fnames = process.argv.slice(3,-1)
    out_dir = process.argv.slice(-1)[0]
  else
    fnames = [process.argv[2]]
    out_dir = process.argv[3]
  for fname in fnames
    code = exports.compile fs.readFileSync fname
    if out_dir
      fs.writeFileSync(out_dir + fname.split('/').slice(-1)[0].replace('.kal','.js'), code)
    else
      console.log code
      console.log eval(code)