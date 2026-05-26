<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<body>
<!-- 测试1：绝对路径 -->
<img src="/myhomework/static/images/gaijin.png" alt="测试1"><br>
<!-- 测试2：相对路径 -->
<img src="./static/images/gaijin.png" alt="测试2"><br>
<!-- 测试3：直接写Tomcat完整URL -->
<img src="http://localhost:8080/myhomework/static/images/gaijin.png" alt="测试3">
</body>
</html>