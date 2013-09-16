pg = require 'pg'
sql = require 'sql'
async = require 'async'
sql.setDialect 'postgres'

class pgEngine
  constructor: (engineConfig) ->
    @client = new pg.Client engineConfig
    @client.connect()

  beforeFix: (data, cb) ->
    cb null, data

  beforeFixRecord: (data, cb) ->
    cb null, data

  afterFixRecord: (err, cb) ->
    cb err

  afterFix: (err, cb) ->
    @client.end()
    cb err

  fix: (data, cb) ->
    @beforeFix data, (err, data) =>
      if err
        return cb err
      cbErr = null

      q = async.queue (task, cb) =>
        @_fixRecord task.table, task.record, (err) ->
          if err and not cbErr
            cbErr = err
          cb()
      , 1

      q.drain = () =>
        @afterFix cbErr, cb

      for table, records of data
        for record in records
          q.push
            table: table
            record: record

  _fixRecord: (table, record, cb) ->
    @beforeFixRecord record, (err, data) =>
      query = @_getQuery table, record
      values = (value for column, value of record)
      @client.query query, values, (err) =>
        @afterFixRecord err, cb

  _getQuery: (table, record) ->
    columns = (column for column, value of record)
    table = sql.define
      name: table
      columns: columns
    insert = table.insert record
    query = new sql.dialect().getQuery insert
    return query.text

module.exports = pgEngine
