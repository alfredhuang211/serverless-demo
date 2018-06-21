const CONF = {
    port: '5757',
    rootPathname: '',

    // 微信小程序 App ID
    appId: 'xxxxxxxxxx',

    // 微信小程序 App Secret
    appSecret: 'xxxxxxxxxx',

    // 是否使用腾讯云代理登录小程序
    useQcloudLogin: false,

    /**
     * MySQL 配置，用来存储 session 和用户信息
     */
    mysql: {
        sh: {
            host: 'sh-cdb-xxxxxxxxxx.sql.tencentcdb.com',
            port: 63374,
            user: 'root',
            db: 'cAuth',
            pass: 'aaaaaaa',
            char: 'utf8mb4'
        }
    },

    // 微信登录态有效期
    wxLoginExpires: 7200,
    wxMessageToken: 'abcdefgh'
};

module.exports = CONF;
