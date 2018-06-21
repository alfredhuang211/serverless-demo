/**
 * scf入口
 * @description 本例描述了weapp-apigw-scf_login的登录过程
 * @param {object} event 接收到的请求信息
 * @param {object} context 上下文环境
 * @param {function} callback 响应请求
 */


// middleware
const { authorization } = require('./auth-sdk')

exports.main_handler = (event, context, callback) => {
  console.log("scf entry")
  console.log(event)
  console.log(context)

  authorization(event).then((result) => {
    // 登录信息会被存储到result中
    if (result.loginState) {
      const response = {
        code: 0,
        data: {
          skey: result.skey,
          userinfo: result.userinfo,
          time: Math.floor(Date.now() / 1000)
        }
      };
      callback(null, response);
    } else {
      callback(null, {
        code: 0,
        msg: 'result.loginState = false'
      });
    }
  })
};