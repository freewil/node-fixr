{basename} = require 'path'

class Fixr
  constructor: (@engineConfig, @engine = 'pg') ->
    
  fix: (data, cb) ->
    if typeof data isnt 'object'
      data = require data
    Engine = require './engines/' + basename(@engine)
    engine = new Engine @engineConfig
    if typeof @beforeFix is 'function'
      engine.beforeFix = @beforeFix
    engine.fix data, cb
    
module.exports = Fixr