// depend
const http = require('axios');
const config = require('../config');
const AuthDbService = require('./mysql/AuthDbService');
const sha1 = require('./helper/sha1');
const aesDecrypt = require('./helper/aesDecrypt');
const { ERRORS, LOGIN_STATE } = require('./constants');

/**
 * 授权模块
 * @param {scf request} event
 * @return {Promise}
 * @example 基于 scf
 * authorization(event).then(result => { // ...some code })
 */
function authorization(event) {
    console.log("authorization entry");
    // 小程序登录校验所需请求头
    const {
        'x-wx-code': code,
        'x-wx-encrypted-data': encryptedData,
        'x-wx-iv': iv
    } = event.headers;

    // 检查 headers
    if ([code, encryptedData, iv].some(v => !v)) {
        throw new Error(ERRORS.ERR_HEADER_MISSED)
    }

    // 通过code获取 session key
    return getSessionKey(code)
        .then(pkg => {
            const { session_key } = pkg;
            // 生成 3rd_session
            const skey = sha1(session_key);

            // 解密数据
            let decryptedData;
            try {
                decryptedData = aesDecrypt(session_key, iv, encryptedData)
                decryptedData = JSON.parse(decryptedData)
                console.log("decryptedData:" + JSON.stringify(decryptedData));
            } catch (e) {
                throw new Error(`${ERRORS.ERR_IN_DECRYPT_DATA}\n${e}`)
            }

            // 连接数据库，写入/更新用户信息
            return new Promise((resolve, reject) => {
                AuthDbService.saveUserInfo(
                    decryptedData,
                    skey,
                    session_key,
                    (userinfo, skey) => {
                        resolve({
                            skey,
                            loginState: LOGIN_STATE.SUCCESS,
                            userinfo
                        })
                    })
            })
        })
}

/**
 * session key 交换
 * @param {string} code
 * @return {Promise}
 */
function getSessionKey(code) {
    // 开发者的appid和appsecret
    const appid = config.appId;
    const appsecret = config.appSecret;
    console.log("getSessionKey start");

    // 通过code换取session和openid
    return http({
        url: 'https://api.weixin.qq.com/sns/jscode2session',
        method: 'GET',
        params: {
            appid: appid,
            secret: appsecret,
            js_code: code,
            grant_type: 'authorization_code'
        }
    }).then(res => {
        res = res.data;
        if (res.errcode || !res.openid || !res.session_key) {
            throw new Error(`${ERRORS.ERR_GET_SESSION_KEY}\n${JSON.stringify(res)}`)
        } else {
            return res
        }
    })
}

module.exports = {
    authorization
};
