# javaweb

实验8/9/10

## 快速启动（IntelliJ IDEA Community）
1. 使用 IntelliJ IDEA Community 版打开本目录，等待 Maven 自动导入（包含 Jetty 插件）。
2. 确保本地 MySQL 中存在 `DBcm` 数据库以及 `medicine` 表，并更新 JSP/Servlet 中的数据库账号密码以匹配本地环境。
3. 在右侧 Maven 工具窗口运行 `jetty:run`，或在终端执行：
   ```bash
   mvn jetty:run
   ```
4. 当前项目使用 **Servlet 4 (javax.servlet)** 依赖，适配 Tomcat 9 / Jetty 9 等主流容器；如需迁移到新版 Tomcat 10+，可改用 `jakarta.servlet` 依赖并调整包名。
5. 访问 <http://localhost:8080/> 体验中药材列表、购物车及药材信息管理页面。
