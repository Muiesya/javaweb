# javaweb

实验8/9/10

## 快速启动（IntelliJ IDEA Ultimate + Tomcat 10）
1. 使用 IntelliJ IDEA Ultimate 打开本目录，等待 Maven 自动导入（本项目依赖 Jakarta Servlet 5.0，已适配 Tomcat 10）。
2. 确保本地 MySQL 中存在 `DBcm` 数据库以及 `medicine` 表，并更新 JSP/Servlet 中的数据库账号密码以匹配本地环境；若未准备数据库，可直接使用内置示例药材数据浏览和下单。
3. 配置运行环境：
   - 在 **Run/Debug Configurations** 中新增 **Tomcat Server | Local**，选择已安装的 Tomcat 10；
   - 在 **Deployment** 里添加 Artifact 选择 `javaweb9:war exploded`（或 `javaweb9.war`），设置应用路径为 `/javaweb9`；
   - 在 **Server** 标签页将 **URL** 设为 `http://localhost:8080/javaweb9/`。
4. 启动 Tomcat 后访问 <http://localhost:8080/javaweb9/> 进入登陆页，体验登陆、会话检查、单点登录，以及商城/购物车/下单等示例流程。
