# javaweb

实验8/9/10

## 快速启动（IntelliJ IDEA Community）
1. 使用 IntelliJ IDEA Community 版打开本目录，等待 Maven 自动导入。
2. 确保本地 MySQL 中存在 `DBcm` 数据库以及 `medicine` 表，并更新 JSP/Servlet 中的数据库账号密码以匹配本地环境。
3. 打包生成 WAR：
   ```bash
   mvn -DskipTests package
   ```
4. 将生成的 `target/javaweb-1.0-SNAPSHOT.war` 放入 Tomcat 9 等 Servlet 4（`javax.servlet`）容器的 `webapps` 目录，或在 IDE 中配置 Tomcat 运行。
5. 启动容器后访问 <http://localhost:8080/javaweb-1.0-SNAPSHOT/> 体验中药材列表、购物车及药材信息管理页面。
