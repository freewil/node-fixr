{randomBytes} = require 'crypto'
assert = require 'assert'
Fixr = require '../src/'
engineConfig = require './pgEngineConfig'
beforeFix = require './helpers/myusers_beforefix'

describe 'Fixr', ->
  data = {}
  fixr = {}
  
  beforeEach (done) ->
    # create random data
    randomBytes 25, (err, buf) ->
      random = buf.toString 'hex'
      assert.ifError err
      data = 
        myusers: [
          {
            email: "#{random}@example.com"
            password: 'password'
          },
          {
            email: "#{random}2@example.com"
            password: 'password2'
          }
        ]
      # setup fixr
      fixr = new Fixr engineConfig
      fixr.beforeFix = beforeFix
      done()
      
  describe 'with pgEngine', ->  
    it 'should be able to load multiple records', (done) ->
      fixr.fix data, done
    it 'should be able to require a fixture file', (done) ->
      fixr.fix "#{__dirname}/fixtures/users", done
