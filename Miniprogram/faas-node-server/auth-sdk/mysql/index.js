const configs = require('../../config')
const mysql = require('mysql')

const connection = mysql.createConnection({
  host: configs.mysql.sh.host,
  port: configs.mysql.sh.port,
  user: configs.mysql.sh.user,
  database: configs.mysql.sh.db,
  password: configs.mysql.sh.pass
});
connection.connect();

modules.exports = connection