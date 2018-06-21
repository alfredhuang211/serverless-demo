// depend
const uuidGenerator = require('uuid/v4')
const moment = require('moment')
const ERRORS = require('../constants').ERRORS
const configs = require('../../config')
const mysql = require('mysql')

/**
 * 储存用户信息
 * @param {object} userInfo
 * @param {string} skey
 * @param {string} sessionKey
 * @param {function} callback
 * @return {Promise}
 */
function saveUserInfo(userInfo, skey, session_key, callback) {
    const uuid = uuidGenerator()
    const create_time = moment().format('YYYY-MM-DD HH:mm:ss')
    const last_visit_time = create_time
    const open_id = userInfo.openId
    const user_info = JSON.stringify(userInfo)

    console.log("userInfo:" + userInfo);
    console.log("skey:" + skey);
    console.log("session_key:" + session_key);

    // 建立sql连接
    const connection = mysql.createConnection({
        host: configs.mysql.sh.host,
        port: configs.mysql.sh.port,
        user: configs.mysql.sh.user,
        database: configs.mysql.sh.db,
        password: configs.mysql.sh.pass
    });
    connection.connect();

    // sql查询
    connection.query('SELECT * FROM cSessionInfo WHERE open_id=' + '"' + open_id + '"', (error, results, fields) => {
        console.log("open_id:" + open_id)
        console.log("results:", results)
        console.log("typeof results:", typeof results)

        // 用户不存在则插入
        if (results instanceof Array && results.length === 0) {
            console.log("has not user")
            const params = [open_id, uuid, skey, create_time, last_visit_time, session_key, user_info]
            connection.query("insert into cSessionInfo(open_id, uuid, skey, create_time, last_visit_time, session_key, user_info) values (?,?,?,?,?,?,?)", params, (error, results, fields) => {
                console.log("insert")
                if (error) console.log(error);
                callback(
                    userInfo,
                    skey
                )
                connection.end()
            })
        }
        // 用户存在则更新
        else {
            console.log("has user")
            const params = [uuid, skey, create_time, last_visit_time, session_key, user_info]
            connection.query("update cSessionInfo set uuid=?,skey=?,create_time=?,last_visit_time=?,session_key=?,user_info=? where open_id=" + "'" + open_id + "'", params, (error, results, fields) => {
                console.log("update")

                if (error) console.log(error);
                callback(
                    userInfo,
                    skey
                )
                connection.end()
            })
        }
    })
}

module.exports = {
    saveUserInfo
}
