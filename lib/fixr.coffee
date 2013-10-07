{basename} = require 'path'

class Fixr
  constructor: (@engineConfig, @engine = 'pg') ->
    
  fix: (data, cb) ->
    if typeof data isnt 'object'
      data = require data
    Engine = require './engines/' + basename(@engine)
    engine = new Engine @engineConfig
    
    # set any optional engine hooks
    if typeof @beforeFix is 'function'
      engine.beforeFix = @beforeFix
    if typeof @afterFix is 'function'
      engine.afterFix = @afterFix
    if typeof @beforeFixRecord is 'function'
      engine.beforeFixRecord = @beforeFixRecord
    if typeof @afterFixRecord is 'function'
      engine.afterFixRecord = @afterFixRecord
    
    engine.fix data, cb
    
module.exports = Fixr