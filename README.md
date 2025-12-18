# javaweb

实验8/9/10

## 快速启动（IntelliJ IDEA Ultimate + Tomcat 10）
1. 使用 IntelliJ IDEA Ultimate 打开本目录，等待 Maven 自动导入（本项目依赖 Jakarta Servlet 5.0，已适配 Tomcat 10）。
2. 确保本地 MySQL 中存在 `DBcm` 数据库以及 `medicine` 表，并更新 JSP/Servlet 中的数据库账号密码以匹配本地环境；若未准备数据库，可直接使用内置示例药材数据浏览和下单。
3. 配置运行环境：
   - 在 **Run/Debug Configurations** 中新增 **Tomcat Server | Local**，选择已安装的 Tomcat 10；
   - 在 **Deployment** 里添加 Artifact 选择 `javaweb:war exploded`（或 `ROOT.war`），将 **Application context** 留空（默认即为 `/`）；
   - 在 **Server** 标签页保持 **URL** 为 `http://localhost:8080/`。
4. 启动 Tomcat 后访问 <http://localhost:8080/> 即可进入首页并继续登录、会话检查、单点登录，以及商城/购物车/下单等示例流程。
