# Fixr

Create data fixtures for testing Node.js projects.

Currently only works with Postgres, more engines can be easily added for
other SQL servers.

## Example

### fixtures/users.json

```json
{
  "users": [
    {
      "email": "user1@example.com",
      "password": "CFDD77B787114C"
    },
    {
      "email": "user2@example.com",
      "password": "3C404BD9DA9523"
    }
  ]
}
```

### users_test.js

```js
var Fixr = require('fixr');
var assert = require('assert');

var engineConfig = {
  "host": "localhost",
  "port": 5432,
  "database": "mydb_test",
  "user": "postgres",
  "password": ""
};

var fixr = new Fixr(engineConfig);
fixr.fix('./fixtures/users', function(err) {
  assert.ifError(err);
  console.log('fixture data loaded!');
  /*
   * do some test that requires user data loaded by the fixture
   */
});
```

## Install

```
npm install fixr
```

## Mentions
* SQL statement generation provided by [sql](https://github.com/brianc/node-sql)
