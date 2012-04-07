module.exports = beforeFix = (data, cb) ->
  query = 'CREATE TEMP TABLE myusers (email varchar, password varchar)'
  this.client.query query, (err) ->
    cb err, data
