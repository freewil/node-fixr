assert = require 'assert'
{randomBytes} = require 'crypto'
fixr = require '../'
beforeFix = require './helpers/myusers_beforefix'
pgEngineConfig = require './pgEngineConfig'

describe 'pgEngine', ->
  engine = new fixr.pgEngine pgEngineConfig
  record = {}
  
  before (done) ->
    randomBytes 25, (err, buf) ->
      assert.ifError err
      record =
        email: buf.toString('hex') + '@example.com'
        password: 'mypassword'
      done()
      
  describe '_getQuery()', ->
    it 'should produce an INSERT statement for a record', ->
      query = engine._getQuery 'myusers', record
      assert.equal query, 'INSERT INTO "myusers" ("email", "password") VALUES ($1, $2)'
      
  describe '_fixRecord()', ->
    it 'should insert a single record', (done) ->
      # hackish way to force beforeFix to be called to create temp table
      # since we are skipping fix() and calling _fixRecord() directly for testing
      engine.beforeFix = beforeFix
      engine.beforeFix record, (err, data) ->
        assert.ifError err
        engine._fixRecord 'myusers', record, done
