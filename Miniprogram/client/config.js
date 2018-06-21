/**
 * 小程序配置文件
 */

// 此处域名修改成API网关的域名
//var host = 'http://127.0.0.1:5000';
var host = 'http://xxxxxxxxxx.ap-shanghai.apigateway.myqcloud.com/release';

var config = {

    // 下面的地址配合 API 网关的 API 配置
    service: {
        host,

        // 登录API，用于建立会话
        loginUrl: `${host}/login`
    }
};

module.exports = config;
