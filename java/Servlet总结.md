#Servlet总结

###URL通配符两种固定的格式

```
1) *.扩展名,比如sayhi.do
2) /ServletName/*,这种优先级大
```

###实例对象的预装载<load-on-startup>标签

```
<servlet>
    <servlet-name>invoker</servlet-name>
    <servlet-class>org.apache.catalina.servlets.InvokerServlet</servlet-class>
    <load-on-startup>2</load-on-startup>
</servlet>     
```

###ServletConfig对象,获取Servlet的初始化参数

```
<servlet>
    <servlet-name>ServletDemo4</servlet-name>
    <servlet-class>cn.itcast.web.servlet.ServletDemo4</servlet-class>
    <init-param>
      <param-name>charset</param-name>
      <param-value>UTF-8</param-value>
    </init-param>
</servlet>
```

###获取单个参数值

```
String value = config.getInitParameter("charset"); 
```

###获取多个参数值

```
Enumeration e = config.getInitParameterNames();
while(e.hasMoreElements()){
	String name = (String) e.nextElement();
	String value = 	config.getInitParameter(name);
	System.out.println(name + "=" + value);
} 
```

###获取web应用的初始化参数

```
<web-app>
    <context-param>
    	<param-name>username</param-name>
      <param-value>root</param-value>
    </context-param> 
</web-app>
```

```
String url = this.getServletContext().getInitParameter("url");
```

注意这里是this.getServletContext不是this.getServletConfig。

###获取文件MIME类型的值

```
String mimeType=this.getServletContext().getMimeType(filename)); 
```

###利用ServletContext对象读取src下面的配置文件

```
ServletContext context = this.getServletContext();
//定位绝对路径
String realpath = context.getRealPath("/WEB-INF/classes/db.properties");  
//获取到操作文件名   
String filename = realpath.substring(realpath.lastIndexOf("\\") + 1);
System.out.println("当前读到的文件是：" + filename); 
FileInputStream in = new FileInputStream(realpath);
Properties prop = new Properties();
prop.load(in); 
String url = prop.getProperty("url");
String username = prop.getProperty("username");
String password = prop.getProperty("password"); 
```

###web工程中普通的java程序中如何读取资源文件

```
lassLoader loader = StudentDao.class.getClassLoader();
//此时仍然把资源装载近内存中
URL url = loader.getResource("cn/itcast/dao/db.properties");
//获取其绝对路径
String filepath = url.getPath();
FileInputStream in = new FileInputStream(filepath);
Properties prop = new Properties();
prop.load(in);
String dburl = prop.getProperty("url");
String username = prop.getProperty("username");
String password = prop.getProperty("password");
```

###获得Servlet的显示名称

```
String name = this.getServletContext().getServletContextName();
```

###SingleThreadModel接口 解决多线程安全问题

如果某个Servlet实现了SingleThreadModel接口，那么Servlet引擎将以单线程模式来调用其service方法。SingleThreadModel接口中没有定义任何方法，只要在Servlet类的定义中增加实现SingleThreadModel接口的声明即可。对于实现了SingleThreadModel接口的Servlet，Servlet引擎仍然支持对该Servlet的多线程并发访问，其采用的方式是产生多个Servlet实例对象，并发的每个线程分别调用一个独立的Servlet实例对象。

###ServletContext对象介绍 

Web容器在启动时，它会为每个Web应用程序都创建一个对应的ServletContext对象，它代表当前web应用。 ServletConfig对象中维护了ServletContext对象的引用，开发人员在编写servlet时，可以通过ServletConfig.getServletContext方法获得ServletContext对象。由于一个Web应用中的**所有Servlet共享同一个ServletContext对象**，因此Servlet对象之间可以**通过ServletContext对象来实现通讯**。ServletContext对象通常也被称之为context域对象。

###ServletContext转发

```
//转发的Servlet的路径是Servlet的映射路径
RequestDispatcher rd = this.getServletContext().getRequestDispatcher("/view.jsp");
rd.forward(request, response);
```

###Response用writer输出中文数据

```
response.setCharacterEncoding("UTF-8");  
response.setHeader("content-type", "text/html;charset=UTF-8");
或者
esponse.setCharacterEncoding("UTF-8");  //多写一句，增强可读性
response.setContentType("text/html;charset=UTF-8"); 
```

###中文文件下载

```
String path = this.getServletContext().getRealPath("/download/中文.jpg");
String filename = path.substring(path.lastIndexOf("\\") + 1);
//以下载方式打开
esponse.setHeader("content-disposition", "attachment;filename="+URLEncoder.encode(filename, "UTF-8")); 
FileInputStream in = null;
try {
		// 输出二进制数据getOutputStream() => ServletOuputStream 类型
		// 输出文本数据getWriter() => PrintWriter 类型
    OutputStream out = response.getOutputStream();
    in = new FileInputStream(path);
    byte buffer[] = new byte[1024];
    int len = 0;
    
    while((len = in.read(buffer)) > 0) {
      out.write(buffer,0,len);
    }
} finally {
    if(in != null) {
      in.close();
    }
} 
```

###发送http头以便控制浏览器定时刷新网页

```
response.setHeader("refresh", "3");
response.setHeader("refresh", "3;url=/day06/index.jsp");
response.getWriter().write("<meta http-equiv='refresh' content='3;url=/day06/index.jsp'>");
```

###禁止缓冲当前文档内容

```
response.setDateHeader("expires", -1);
response.setDateHeader("Cache-Control", no-cache); 
response.setDateHeader("Pragma", no-cache); 
```

###设置过期时间

```
long expriestime = System.currentTimeMillis() + 1*24*60*60*1000;
response.setDateHeader("expires", expriestime);
```

###通过response实现请求重定向

```
response.setStatus(302);
response.setHeader("location", "/day06/index.jsp");
或者
response.sendRedirect("/day06/index.jsp");
```

###referer防止盗链

```
String referer = request.getHeader("referer");
if(referer == null || !referer.startsWith("http://localhost")) {
	response.sendRedirect("/day06/index.jsp");
  return;
}
```

###request请求参数中文乱码问题

```
// POST
request.setCharacterEncoding("UTF-8"); 
// GET
String username = request.getParameter("username");
username = new String(username.getBytes("iso8859-1"),"UTF-8");
```

###Cookie类常用方法

```
1) public Cookie(String name, String value)
2) setValue和getValue
3) setMaxAge和getMaxAge
4) setPath和getPath
5) setDomain和getDomain
6) getName
```

###Session对象失效的方式

```
1) 执行session.invalidate();直接摧毁
2) 在web.xml文件中设置,在<web-app />根标签下面
<session-config>
	<session-timeout>10</sessiontimeout> //（单位：分钟）
</session-config> 
```

###多浏览器共享session对象

```
Cookie cookie = new Cookie("JSESSIONID",session.getId());
cookie.setMaxAge(30*60);
cookie.setPath("/day07");
response.addCookie(cookie); 
```

###URL带sessionid重写

```
1) 对SendRedirect方法的重写
String url=response.encodeRedirectURL("/day07/servlet/ListCartServlet");
response.sendRedirect(url);
2) 对表单action和超链接的url地址进行重写
String url = "/day07/servlet/BuyServlet?id=" + book.getId();
url = response.encodeURL(url);
out.print(book.getName() + "<a href='" + url + "'>购买</a><br/>");
```