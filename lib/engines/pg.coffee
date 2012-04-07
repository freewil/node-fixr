pg = require 'pg'
sql = require 'sql'
sql.setDialect 'postgres'

class pgEngine
  constructor: (engineConfig) -> 
    @client = new pg.Client engineConfig
    @client.connect()
    
  beforeFix: (data, cb) ->
    cb null, data
    
  fix: (data, cb) ->
    @beforeFix data, (err, data) =>
      if err
        return cb err
      cbErr = null
      @client.on 'drain', ->
        cb cbErr
      for table, records of data
        for record in records
          @_fixRecord table, record, (err) ->
            if err and not cbErr
              cbErr = err
            
  _fixRecord: (table, record, cb) ->
    query = @_getQuery table, record
    values = (value for column, value of record)
    @client.query query, values, cb
    
  _getQuery: (table, record) ->
    columns = (column for column, value of record)
    table = sql.define
      name: table
      columns: columns
    insert = table.insert record
    query = new sql.dialect().getQuery insert
    return query.text
  
module.exports = pgEngine