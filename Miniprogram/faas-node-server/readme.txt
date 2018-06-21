.
├── auth-sdk
│   ├── config.js
│   ├── constants.js #常量表
│   ├── helper #辅助类
│   │   ├── aesDecrypt.js
│   │   ├── md5.js
│   │   └── sha1.js
│   ├── index.js #授权模块
│   └── mysql
│       ├── AuthDbService.js #db存储/更新模块
│       └── index.js #建立数据库连接入口
├── config.js #配置文件
├── index.js #scf入口文件
├── package-lock.json #项目依赖源映射
├── package.json #项目依赖
├── readme.txt #项目结构
├── scf-login.zip # 项目zip包
└── tools
    └── init.sql #建表sql