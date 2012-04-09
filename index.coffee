path = if process.env.FIXR_COV then './lib-cov' else './lib'
module.exports =
  Fixr: require "#{path}/index"
  pgEngine: require "#{path}/engines/pg"
