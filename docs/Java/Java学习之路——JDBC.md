# Java学习之路——JDBC

## 概述

> 持久化(persistence)：**把数据保存到可掉电式存储设备中以供之后使用**。大多数情况下，特别是企业级应用，**数据持久化意味着将内存中的数据保存到硬盘**上加以”固化”**，而持久化会将内存中的数据存储在关系型数据库中，或者存储在磁盘文件、XML数据文件中**。

而我们将要学习的 JDBC 就是为了实现在 Java 程序中的数据持久化而诞生的。

![1555575721407](https://pic.try-hard.cn/blog/数据持久化.png)

## 一、JDBC 基础知识

### 1. Java中的数据存储技术

- 在Java中，数据库存取技术可分为如下几类：
  - **JDBC(Java Database Connectivity)**：是 Java 语言中用来规范客户端程序如何来访问数据库的应用程序接口，提供了诸如查询和更新数据库中数据的方法；
  - **JDO (Java Data Object )技术**：Java 对象持久化的规范，也是一个用于存取某种数据仓库中的对象的标准化API；

  - **第三方O/R工具**：如 Hibernate, Mybatis 等。

- JDBC 是 Java 程序访问数据库的基石，JDO、Hibernate、MyBatis 等只是更好的封装了 JDBC。

###  2. JDBC 介绍

JDBC(Java Database Connectivity)是一个**独立于特定数据库管理系统、通用的 SQL 数据库存取和操作的公共接口**（一组API），定义了用来访问数据库的标准Java类库，（`java.sql,javax.sql`）使用这些类库可以以一种标准的方法、方便地访问数据库资源。

JDBC **为访问不同的数据库提供了一种统一的途径**，为开发者屏蔽了一些细节问题，使Java程序员使用 JDBC 可以连接任何**提供了JDBC驱动程序**的数据库系统，这样就使得程序员无需对特定的数据库系统的特点有过多的了解，从而大大简化和加快了开发过程。

### 3. 数据库访问方式比较

- **普通方式连接**：
- ![普通方式](https://pic.try-hard.cn/blog/普通方式.png)

- **使用 JDBC 连接**：
- ![JDBC连接数据库](https://pic.try-hard.cn/blog/JDBC连接数据库.png)

通过对比可以发现 Java 使用 JDBC 访问数据库时，程序的可移植性大大提高。因为程序是和 JDBC 进行交互的，没有和底层数据库交互。即使数据库更换了，由 JDBC 自行适应新的数据库即可，Java 程序本身完全不用关心底层数据库是否改变。

### 4. JDBC 体系结构

JDBC接口（API）包括两个层次：

- **面向应用的API**：Java API，抽象接口，供应用程序开发人员使用（连接数据库，执行SQL语句，获得结果）；
- **面向数据库的API**：Java Driver API，供开发商开发数据库驱动程序用。

### 5. JDBC 开发流程

> ODBC（**Open Database Connectivity**，开放式数据库连接），是微软在Windows平台下推出的。使用者在程序中只需要调用ODBC API，由 ODBC 驱动程序将调用转换成为对特定的数据库的调用请求。

![JDBC 开发流程](https://pic.try-hard.cn/blog/JDBC 开发流程.png)

## 二、数据库链接准备工作

### 1. 配置 JDBC 驱动

`java.sql.Driver` 接口是所有 JDBC 驱动程序需要实现的接口。这个接口是提供给数据库厂商使用的，不同数据库厂商提供不同的实现。在我们的 Java 程序中不需要直接去访问实现了 Driver 接口的类，而是由驱动程序管理器类（``java.sql.DriverManager`）去调用这些Driver实现。

习惯上将从各大数据库官网上下载的 jar 包拷贝到 Java 工程中与 src 文件夹同级的 lib 文件夹，并将这个 jar 包添加到工程中（如果是Dynamic Web Project（动态的web项目）话，则是把驱动jar放到WebContent（有的开发工具叫 WebRoot）目录中的WEB-INF目录中的lib目录下即可）。

### 2. 加载和注册 JDBC 驱动

- 加载驱动：加载 JDBC 驱动需调用 Class 类的静态方法 forName()，向其传递要加载的 JDBC 驱动的类名

  - **Class.forName(“com.mysql.jdbc.Driver”);**

- 注册驱动：DriverManager 类是驱动程序管理器类，负责管理驱动程序
  - **使用DriverManager.registerDriver(com.mysql.jdbc.Driver)来注册驱动**
  - 通常不用显式调用 DriverManager 类的 registerDriver() 方法来注册驱动程序类的实例，因为 Driver 接口的驱动程序类**都**包含了静态代码块，在这个静态代码块中，会调用 DriverManager.registerDriver() 方法来注册自身的一个实例。

### 3. URL

JDBC URL 用于标识一个被注册的驱动程序，驱动程序管理器通过这个 URL 选择正确的驱动程序，从而建立到数据库的连接。

JDBC URL的标准由三部分组成，各部分间用冒号分隔：

**格式**：jdbc:子协议:子名称

- **协议**：JDBC URL中的协议总是 jdbc ；
- **子协议**：子协议用于标识一个数据库驱动程序；
- **子名称**：一种标识数据库的方法。子名称可以依不同的子协议而变化，用子名称的目的是为了**定位数据库**提供足够的信息。包含**主机名**(对应服务端的ip地址)**，端口号，数据库名**；

**示例**：`jdbc:mysql://localhost:3306/test`

几种常用数据库的 JDBC URL：

- **MySQL**：

  - `jdbc:mysql://主机名称:mysql服务端口号/数据库名称?参数=值&参数=值`
  - `jdbc:mysql://localhost:3306/atguigu`
  - `jdbc:mysql://localhost:3306/atguigu?useUnicode=true&characterEncoding=utf8（如果JDBC程序与服务器端的字符集不一致，会导致乱码，那么可以通过参数指定服务器端的字符集）`
  - `jdbc:mysql://localhost:3306/atguigu?user=root&password=123456`

- **Oracle 9i**：

  - `jdbc:oracle:thin:@主机名称:oracle服务端口号:数据库名称`
  - `jdbc:oracle:thin:@localhost:1521:atguigu`

- **SQLServer**：

  - `jdbc:sqlserver://主机名称:sqlserver服务端口号:DatabaseName=数据库名称`
  - `jdbc:sqlserver://localhost:1433:DatabaseName=atguigu`

  ### 4. 添加用户名与密码

  添加数据库用户名与密码可以通过以下两种方式进行：

  - user 和 password 可以用“属性名=属性值”方式告诉数据库；
  - 可以调用 DriverManager 类的 getConnection() 方法建立到数据库的连接。

## 三、数据库连接

### 方式一：显式使用第三方数据库API

该方式显式使用第三方数据库的 API。

```java
import java.sql.Connection;
import java.sql.Driver;
import java.sql.SQLException;
import java.util.Properties;

public class Demo {
    public static void main(String[] args) throws SQLException {
        try {
            // 1.提供java.sql.Driver接口实现类的对象
            Driver driver = new com.mysql.cj.jdbc.Driver();

            // 2.提供url，指明具体操作的数据库
            String url = "jdbc:mysql://localhost:3306/demo";

            // 3. 提供Properties对象，指明用户名和密码
            Properties info = new Properties();
            info.setProperty("user", "root");
            info.setProperty("password", "123456abc");

            // 4. 调用driver的connect获取连接
            Connection conn = driver.connect(url, info);
            System.out.println(conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
```

### 方式二：使用反射实例化Driver

相较于方式一，这里使用反射实例化 Driver，不在代码中体现第三方数据库的 API。体现了面向接口编程思想。

```java
import java.sql.Connection;
import java.sql.Driver;
import java.sql.SQLException;
import java.util.Properties;

public class Demo {
    public static void main(String[] args) throws SQLException {
        try {
            // 1.实例化Driver
            String className = "com.mysql.cj.jdbc.Driver";
            Class clazz = Class.forName(className);
            Driver driver = (Driver) clazz.newInstance();


            // 2.提供url，指明具体操作的数据库
            String url = "jdbc:mysql://localhost:3306/demo";

            // 3. 提供Properties对象，指明用户名和密码
            Properties info = new Properties();
            info.setProperty("user", "root");
            info.setProperty("password", "123456abc");

            // 4. 调用driver的connect获取连接
            Connection conn = driver.connect(url, info);
            System.out.println(conn);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

### 方式三：使用DriverManager显式注册驱动

方式三使用 DriverManager 实现数据库的连接。

```java
import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Demo {
    public static void main(String[] args) throws SQLException {
        try {
            // 1.数据库连接基本要素
            String driverName = "com.mysql.cj.jdbc.Driver";
            String url = "jdbc:mysql://localhost:3306/demo";
            String user = "root";
            String password = "123456abc";

            // 2.实例化 Driver
            Class clazz = Class.forName(driverName);
            Driver driver = (Driver) clazz.newInstance();

            // 3.注册驱动
            DriverManager.registerDriver(driver);

            // 4.获取连接
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println(conn);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

### 方式四：使用DriverManager隐式注册驱动

不必显式的注册驱动了。因为在 DriverManager 的源码中已经存在静态代码块，实现了驱动的注册。

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Demo {
    public static void main(String[] args) throws SQLException {
        try {
            // 1.数据库连接基本要素
            String driverName = "com.mysql.cj.jdbc.Driver";
            String url = "jdbc:mysql://localhost:3306/demo";
            String user = "root";
            String password = "123456abc";

            // 2.加载驱动
            Class.forName(driverName);

            // 3.获取连接
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println(conn);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

### 方式五：使用配置文件（最终版）

使用配置文件的方式保存配置信息，在代码中加载配置文件。

**使用配置文件的好处：**

- 实现了代码和数据的分离，如果需要修改配置信息，直接在配置文件中修改，不需要深入代码
- 如果修改了配置信息，省去重新编译的过程。

在 Java 程序所在文件夹下新建配置文件`jdbc.properties`：

```properties
user=root
password=123456abc
url=jdbc:mysql://localhost:3306/demo
driverClass=com.mysql.cj.jdbc.Driver
```

```java
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class Demo {
    public static void main(String[] args) throws SQLException {
        try {
            // 1.加载配置文件
            InputStream is = Demo.class.getClassLoader().getResourceAsStream("jdbc.properties");
            Properties properties = new Properties();
            properties.load(is);

            // 2.读取配置信息
            String user = properties.getProperty("user");
            String password = properties.getProperty("password");
            String url = properties.getProperty("url");
            String driverClass = properties.getProperty("driverClass");

            // 3.加载驱动
            Class.forName(driverClass);

            // 4.获取连接
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println(conn);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

## 四、使用PreparedStatement实现CRUD操作

### 1.操作和访问数据库

数据库连接被用于向数据库服务器发送命令和 SQL 语句，并接受数据库服务器返回的结果。其实一个数据库连接就是一个 Socket 连接。

在`java.sql`包中有 3 个接口分别定义了对数据库的调用的不同方式：

- **Statement**：用于执行静态 SQL 语句并返回它所生成结果的对象；
- **PrepatedStatement**：SQL 语句被预编译并存储在此对象中，可以使用此对象多次高效地执行该语句；
- **CallableStatement**：用于执行 SQL 存储过程。

### 2.使用Statement操作数据表

**数据表**：

| ID   | Name | Password |
| ---- | ---- | -------- |
| 1    | 小明 | 123456   |

通过调用 Connection 对象的 createStatement() 方法创建该对象。该对象用于执行静态的 SQL 语句，并且返回执行结果。Statement 接口中定义了下列方法用于执行 SQL 语句：

- `int excuteUpdate(String sql)`：执行更新操作 **INSERT**、**UPDATE**、**DELETE**；
- `ResultSet executeQuery(String sql)`：执行查询操作 **SELECT**。

**示例**：

```java
import java.io.InputStream;
import java.lang.reflect.Field;
import java.sql.*;
import java.util.Properties;
import java.util.Scanner;

public class Demo {
    public static void main(String[] args) throws SQLException {
        Scanner scan = new Scanner(System.in);

        System.out.print("用户名：");
        String userName = scan.nextLine();
        System.out.print("密   码：");
        String password = scan.nextLine();

        String sql = "SELECT name,password FROM user WHERE Name = '" + userName + "' AND PASSWORD = '" + password
                + "'";
        User user = get(sql, User.class);
        if (user != null) {
            System.out.println("登陆成功!");
        } else {
            System.out.println("用户名或密码错误！");
        }
    }

    public static <T> T get(String sql, Class<T> clazz) {
        T t = null;

        Connection conn = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            // 1.加载配置文件
            InputStream is = Demo.class.getClassLoader().getResourceAsStream("jdbc.properties");
            Properties properties = new Properties();
            properties.load(is);

            // 2.读取配置信息
            String user = properties.getProperty("user");
            String password = properties.getProperty("password");
            String url = properties.getProperty("url");
            String driverClass = properties.getProperty("driverClass");

            // 3.加载驱动
            Class.forName(driverClass);

            // 4.获取连接
            conn = DriverManager.getConnection(url, user, password);

            st = conn.createStatement();
            rs = st.executeQuery(sql);

            // 获取结果集的元数据
            ResultSetMetaData rsmd = rs.getMetaData();
            // 获取结果集的列数
            int columnCount = rsmd.getColumnCount();

            if (rs.next()) {
                t = clazz.newInstance();
                for(int i=0 ; i < columnCount ; i++) {
                    // 获取列的名称
                    // String columnName = rsmd.getColumnName(i+1);

                    // 1.获取列的别名
                    String columnName = rsmd.getColumnLabel(i + 1);
                    // 2.根据列名获取对应数据表中的数据
                    Object columnVal = rs.getObject(columnName);
                    // 3.将数据表中得到的数据，封装进对象
                    Field field = clazz.getDeclaredField(columnName);
                    field.setAccessible(true);
                    field.set(t,columnVal);
                }
                return t;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 关闭资源
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (st != null) {
                try {
                    st.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }
}

class User {
    private String name;
    private String password;

    public User() {

    }

    public User(String name, String password) {
        this.name = name;
        this.password = password;
    }

    @Override
    public String toString() {
        return "User{" +
                "name='" + name + '\'' +
                ", password='" + password + '\'' +
                '}';
    }
}
```

但是使用Statement操作数据表存在弊端：

- **存在拼串操作，操作较为繁琐；**
- **存在SQL注入问题。**

### 3. 使用PreparedStatement操作数据表

在 Java 程序中我们可以通过调用 Connection 对象的 **preparedStatement(String sql)** 方法获取 PreparedStatement 对象。

PreparedStatement 接口是 Statement 的子接口，它表示一条预编译过的 SQL 语句。PreparedStatement 对象所代表的 SQL 语句中的参数用问号 (?) 来表示，调用 PreparedStatement 对象的 `setXxx()` 方法来设置这些参数。setXxx() 方法有两个参数，第一个参数是要设置的 SQL 语句中的参数的索引(从 1 开始)，第二个是设置的 SQL 语句中的参数的值。

**PreparedStatement 的主要特点**：

- 代码的可读性和可维护性较高；

- **PreparedStatement 能最大可能提高性能：**
  - DBServer 会对**预编译**语句提供性能优化。因为预编译语句有可能被重复调用，所以语句在被 DBServer 的编译器编译后的执行代码被缓存下来，那么下次调用时只要是相同的预编译语句就不需要编译，只要将参数直接传入编译过的语句执行代码中就会得到执行。
  - 在 statement 语句中,即使是相同操作但因为数据内容不一样,所以整个语句本身不能匹配,没有缓存语句的意义.事实是没有数据库会对普通语句编译后的执行代码缓存。这样<u>每执行一次都要对传入的语句编译一次。</u>

- PreparedStatement 可以防止 SQL 注入 。

**Java与SQL对应数据类型转换表**：

| Java类型           | SQL类型                  |
| ------------------ | ------------------------ |
| boolean            | BIT                      |
| byte               | TINYINT                  |
| short              | SMALLINT                 |
| int                | INTEGER                  |
| long               | BIGINT                   |
| String             | CHAR,VARCHAR,LONGVARCHAR |
| byte   array       | BINARY  ,    VAR BINARY  |
| java.sql.Date      | DATE                     |
| java.sql.Time      | TIME                     |
| java.sql.Timestamp | TIMESTAMP                |

**示例**：

```java
import java.io.InputStream;
import java.lang.reflect.Field;
import java.sql.*;
import java.util.Properties;

public class Demo {
    public static void main(String[] args) {
        String sql;
        sql = "insert into user values (default, ?, ?)";
        DBUtils.update(sql, "小刚", 123456);

        sql = "select name,password from user where name='小刚'";
        System.out.println(DBUtils.getInstance(sql, User.class));
    }
}


/*****************************************************************************/
/***************************  User 类  ***************************************/
/*****************************************************************************/
class User {
    private String name;
    private String password;

    public User() {

    }

    public User(String name, String password) {
        this.name = name;
        this.password = password;
    }

    @Override
    public String toString() {
        return "User{" +
                "name='" + name + '\'' +
                ", password='" + password + '\'' +
                '}';
    }
}


/*****************************************************************************/
/***********************  DBUtils 数据库工具类  ********************************/
/*****************************************************************************/
class DBUtils {
    public static Connection getConnection() throws Exception {
        Connection conn = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            // 1.加载配置文件
            InputStream is = ClassLoader.getSystemClassLoader().getResourceAsStream("jdbc.properties");
            Properties properties = new Properties();
            properties.load(is);

            // 2.读取配置信息
            String user = properties.getProperty("user");
            String password = properties.getProperty("password");
            String url = properties.getProperty("url");
            String driverClass = properties.getProperty("driverClass");

            // 3.加载驱动
            Class.forName(driverClass);

            // 4.获取连接
            conn = DriverManager.getConnection(url, user, password);
            return conn;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void closeResource(Connection conn, PreparedStatement ps) {
        // 关闭资源
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static <T> T getInstance(String sql, Class<T> clazz, Object... args) {
        /*
         * 查询数据库
         * */
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // 1.获取数据库连接
            conn = DBUtils.getConnection();
            // 2.预编译sql语句，得到PreparedStatement对象
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                // 3.填充占位符
                for (int i = 0; i < args.length; i++) {
                    ps.setObject(i + 1, args[i]);
                }
                // 4.执行sql语句得到结果集
                rs = ps.executeQuery();
                // 5.得到结果集的元数据：ResultSetMetaData
                ResultSetMetaData rsmd = rs.getMetaData();
                // 6.通过ResultSetMetaData得到columnCount,columnLabel；通过ResultSet得到列值
                int columnCount = rsmd.getColumnCount();
                if (rs.next()) {
                    T t = clazz.newInstance();
                    for (int i = 0; i < columnCount; i++) {// 遍历每一个列
                        // 获取列值
                        Object columnVal = rs.getObject(i + 1);
                        // 获取列的别名:列的别名，使用类的属性名充当
                        String columnLabel = rsmd.getColumnLabel(i + 1);
                        // 6.2使用反射，给对象的相应属性赋值
                        Field field = clazz.getDeclaredField(columnLabel);
                        field.setAccessible(true);
                        field.set(t, columnVal);
                    }
                    return t;
                }
            }
        } catch (Exception throwables) {
            throwables.printStackTrace();
        } finally {
            DBUtils.closeResource(conn, ps);
        }
        return null;
    }

    public static void update(String sql, Object... args) {
        /*
         * 更新数据库
         * */
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // 1.获取数据库连接
            conn = DBUtils.getConnection();
            // 2.获取PreparedStatement的实例 (或：预编译sql语句)
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                // 3.填充占位符
                for (int i = 0; i < args.length; i++) {
                    ps.setObject(i + 1, args[i]);
                }
                //4.执行sql语句
                ps.execute();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtils.closeResource(conn, ps);
        }
    }
}
```

### 4、ResultSet与ResultSetMetaData

#### ResultSet

查询需要调用`PreparedStatement `的 `executeQuery()` 方法，查询结果是一个**ResultSet** 对象。ResultSet 对象以逻辑表格的形式封装了执行数据库操作的结果集，ResultSet 接口由数据库厂商提供实现。

ResultSet 返回的实际上就是一张数据表。有一个指针指向数据表的第一条记录的前面。它维护了一个指向当前数据行的**游标**，初始的时候，游标在第一行之前，可以通过 ResultSet 对象的 next() 方法移动到下一行。调用 next()方法检测下一行是否有效。若有效，该方法返回 true，且指针下移。相当于Iterator对象的 hasNext() 和 next() 方法的结合体。

**注意：Java与数据库交互涉及到的相关Java API中的索引都从1开始。**

#### ResultSetMetaData

ResultSetMetaData 可用于获取关于 ResultSet 对象中列的类型和属性信息的对象

`ResultSetMetaData meta = rs.getMetaData()`;

**ResultSetMetaData 常用方法**：

- `getColumnName(int column)`：获取指定列的名称；
- `getColumnLabel(int column)`：获取指定列的别名；
- `getColumnCount()`：返回当前 ResultSet 对象中的列数； 

- `getColumnTypeName(int column)`：检索指定列的数据库特定的类型名称；
- `getColumnDisplaySize(int column)`：指示指定列的最大标准宽度，以字符为单位；
- `isNullable(int column)`：指示指定列中的值是否可以为 null；

- `isAutoIncrement(int column)`：指示是否自动为指定列进行编号，这样这些列仍然是只读的。

![image-20210128165134754](https://pic.try-hard.cn/blog/image-20210128165134754.png)

### 5. ORM思想

> **对象关系映射**（英语：**Object Relational Mapping**，简称**ORM**，或**O/RM**，或**O/R mapping**），是一种程序设计技术，用于实现面向对象编程语言里不同类型系统的资料之间的转换。从效果上说，它其实是创建了一个可在编程语言里使用的“虚拟对象数据库”。

![1555579816884](https://pic.try-hard.cn/blog/1555579816884.png)

## 五、操作BLOB类型字段

### 1. MySQL BLOB类型

在 MySQL中，BLOB是一个二进制大型对象，是一个可以存储大量数据的容器，它能容纳不同大小的数据。

使用 Java 程序插入BLOB类型的数据必须使用PreparedStatement，因为BLOB类型的数据无法使用字符串拼接写的。

MySQL的四种BLOB类型(除了在存储的最大信息量上不同外，他们是等同的)：

![1555581069798](https://pic.try-hard.cn/blog/1555581069798.png)

**注意**：

- 实际使用中根据需要存入的数据大小定义不同的 BLOB 类型；
- 如果存储的文件过大，数据库的性能会下降；
- 如果在指定了相关的Blob类型以后，还报错：xxx too large，那么在mysql的安装目录下，找my.ini文件加上如下的配置参数： **max_allowed_packet=16M**。同时注意：修改了my.ini文件之后，需要重新启动mysql服务。

### 2. 插入 BLOB 类型

```java
String sql;
sql = "insert into user values (default, ?, ?, ?)";
DBUtils.update(sql, "小刚", 123456, new FileInputStream("java.png"));    // 剩余代码查看4.3
```

### 3. 从数据表中读取大数据类型

```java
String sql;
PreparedStatement ps;
sql = "select * from user where name='小刚'";

Connection conn = DBUtils.getConnection();
if (conn != null) {
    ps = conn.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
        Blob photo = rs.getBlob(4);
        InputStream is = photo.getBinaryStream();
        OutputStream os = new FileOutputStream("photo.jpg");
        byte[] buffer = new byte[1024];
        int len=0;
        while ((len = is.read(buffer)) != -1) {
        	os.write(buffer, 0, len);
        }

        DBUtils.closeResource(conn, ps);
        rs.close();
        is.close();
        os.close();
    }
}
```

## 六、批量插入

当需要成批插入或者更新记录时，可以采用 Java 的批量**更新**机制，这一机制允许多条语句一次性提交给数据库批量处理。通常情况下比单独提交处理更有效率

JDBC的批量处理语句包括下面三个方法：

- **addBatch(String)：添加需要批量处理的SQL语句或是参数；**
- **executeBatch()：执行批量处理语句；**
- **clearBatch():清空缓存的数据**

通常我们会遇到两种批量执行SQL语句的情况：

- 多条 SQL 语句的批量处理；
- 一个 SQL 语句的批量传参。

### 在数据库中创建数据表

```sql
CREATE TABLE goods(
    id INT PRIMARY KEY AUTO_INCREMENT,
    NAME VARCHAR(20)
);
```

我们下面使用不同的方式一步一步优化向该数据表中插入两千条数据。

### 层次一：使用Statement

```java
long startTime=System.currentTimeMillis();   //获取开始时间

Connection conn = DBUtils.getConnection();
Statement st = conn.createStatement();
for(int i = 1;i <= 2000;i++){
    String sql = "insert into goods values(default, 'name_"+ i +"')";
    st.executeUpdate(sql);
}
conn.close();

long endTime = System.currentTimeMillis(); //获取结束时间
System.out.println("程序运行时间： "+ (endTime - startTime)+"ms");  // 76255ms
```

### 层次二：使用PreparedStatement

```java
long startTime=System.currentTimeMillis();   //获取开始时间

Connection conn = DBUtils.getConnection();
String sql = "insert into goods values(default, ?)";
PreparedStatement ps = conn.prepareStatement(sql);
for(int i = 1;i <= 2000;i++){
    ps.setString(1, "name_" + i);
    ps.executeUpdate();
}
DBUtils.closeResource(conn, ps);

long endTime = System.currentTimeMillis(); //获取结束时间
System.out.println("程序运行时间： "+ (endTime - startTime)+"ms");  // 62970ms
```

### 层次三：使用PreparedStatement的Batch

```java
/*
 * 1. 使用 addBatch() / executeBatch() / clearBatch()
 * 2. mysql服务器默认是关闭批处理的，我们需要通过一个参数，让mysql开启批处理的支持。
 * ?rewriteBatchedStatements=true 写在配置文件的url后面
 * */
long startTime=System.currentTimeMillis();   //获取开始时间

Connection conn = DBUtils.getConnection();
String sql = "insert into goods values(default, ?)";
PreparedStatement ps = conn.prepareStatement(sql);
for(int i = 1;i <= 2000;i++){
    ps.setString(1, "name_" + i);
    //1.“攒”sql
    ps.addBatch();
    if(i % 500 == 0){
        //2.执行
        ps.executeBatch();
        //3.清空
        ps.clearBatch();
    }
}
DBUtils.closeResource(conn, ps);

long endTime = System.currentTimeMillis(); //获取结束时间
System.out.println("程序运行时间： "+ (endTime - startTime)+"ms");  // 1720ms
```

### 层次四：关闭Connection的自动提交

```java
/*
 * 使用Connection 的 setAutoCommit(false)  /  commit()
 * */
long startTime=System.currentTimeMillis();   //获取开始时间

Connection conn = DBUtils.getConnection();
//1.设置为不自动提交数据
conn.setAutoCommit(false);

String sql = "insert into goods values(default, ?)";
PreparedStatement ps = conn.prepareStatement(sql);
for(int i = 1;i <= 2000;i++){
    ps.setString(1, "name_" + i);
    //1.“攒”sql
    ps.addBatch();
    if(i % 500 == 0){
        //2.执行
        ps.executeBatch();
        //3.清空
        ps.clearBatch();
    }
}
//2.提交数据
conn.commit();

DBUtils.closeResource(conn, ps);

long endTime = System.currentTimeMillis(); //获取结束时间
System.out.println("程序运行时间： "+ (endTime - startTime)+"ms");  // 1692ms
```

## 七、事务

### 1. 数据库事务介绍

**事务：一组逻辑操作单元,使数据从一种状态变换到另一种状态。**

**事务处理（事务操作）：**保证所有事务都作为一个工作单元来执行，即使出现了故障，都不能改变这种执行方式。当在一个事务中执行多个操作时，要么所有的事务都**被提交(commit)**，那么这些修改就永久地保存下来；要么数据库管理系统将放弃所作的所有修改，整个事务**回滚(rollback)**到最初状态。

为确保数据库中数据的**一致性**，数据的操纵应当是离散的成组的逻辑单元：当它全部完成时，数据的一致性可以保持，而当这个单元中的一部分操作失败，整个事务应全部视为错误，所有从起始点以后的操作应全部回退到开始状态。 

### 2. JDBC事务处理

数据一旦提交，就不可回滚。

数据什么时候意味着提交？

- **当一个连接对象被创建时，默认情况下是自动提交事务**：每次执行一个 SQL 语句时，如果执行成功，就会向数据库自动提交，而不能回滚。
- **关闭数据库连接，数据就会自动的提交。**如果多个操作，每个操作使用的是自己单独的连接，则无法保证事务。即同一个事务的多个操作必须在同一个连接下。

**JDBC程序中为了让多个 SQL 语句作为一个事务执行：**

- 调用 Connection 对象的 **setAutoCommit(false);** 以取消自动提交事务
- 在所有的 SQL 语句都成功执行后，调用 **commit();** 方法提交事务
- 在出现异常时，调用 **rollback();** 方法回滚事务

> 若此时 Connection 没有被关闭，还可能被重复使用，则需要恢复其自动提交状态 setAutoCommit(true)。尤其是在使用数据库连接池技术时，执行close()方法前，建议恢复自动提交状态。

**示例**：模拟用户小红向小明转钱

创建数据表

```sql
create table if not exists user
(
	id int auto_increment
		primary key,
	name varchar(20) null,
	balance int null
);

INSERT INTO demo.user (id, name, balance) VALUES (1, '小明', 100);
INSERT INTO demo.user (id, name, balance) VALUES (2, '小红', 100);
```

```java
Connection conn = null;
try {
    // 1.获取数据库连接
    conn = DBUtils.getConnection();
    // 2.开启事务
    conn.setAutoCommit(false);
    String sql;
    sql = "update user set balance = balance - 100 where name = ?";
    DBUtils.update(sql, "小红");

    // 模拟网络异常
    //System.out.println(10 / 0);

    sql = "update user set balance = balance + 100 where name = ?";
    DBUtils.update(sql, "小明");
    conn.commit();
} catch (Exception e) {
    e.printStackTrace();
    // 5.若有异常，则回滚事务
    try {
        conn.rollback();
    } catch (SQLException e1) {
        e1.printStackTrace();
    }
} finally {
    try {
        //6.恢复每次DML操作的自动提交功能
        conn.setAutoCommit(true);
    } catch (SQLException e) {
        e.printStackTrace();
    }
    //7.关闭连接
    conn.close();
}
```

### 3. 事务的ACID属性    

1. **原子性（Atomicity）**
   原子性是指事务是一个不可分割的工作单位，事务中的操作要么都发生，要么都不发生。 

2. **一致性（Consistency）**
   事务必须使数据库从一个一致性状态变换到另外一个一致性状态。

3. **隔离性（Isolation）**
   事务的隔离性是指一个事务的执行不能被其他事务干扰，即一个事务内部的操作及使用的数据对并发的其他事务是隔离的，并发执行的各个事务之间不能互相干扰。

4. **持久性（Durability）**
   持久性是指一个事务一旦被提交，它对数据库中数据的改变就是永久性的，接下来的其他操作和数据库故障不应该对其有任何影响。

### 5. 数据库的并发问题

对于同时运行的多个事务, 当这些事务访问数据库中相同的数据时，如果没有采取必要的隔离机制，就会导致各种并发问题:

- **脏读**: 对于两个事务 T1, T2, T1 读取了已经被 T2 更新但还**没有被提交**的字段。之后, 若 T2 回滚, T1读取的内容就是临时且无效的；
- **不可重复读**: 对于两个事务T1, T2, T1 读取了一个字段, 然后 T2 **更新**了该字段。之后, T1再次读取同一个字段, 值就不同了；
- **幻读**: 对于两个事务T1, T2, T1 从一个表中读取了一个字段, 然后 T2 在该表中**插入**了一些新的行。之后, 如果 T1 再次读取同一个表, 就会多出几行；

- **数据库事务的隔离性**: 数据库系统必须具有隔离并发运行各个事务的能力, 使它们不会相互影响, 避免各种并发问题。

- 一个事务与其他事务隔离的程度称为隔离级别。数据库规定了多种事务隔离级别, 不同隔离级别对应不同的干扰程度, **隔离级别越高, 数据一致性就越好, 但并发性越弱。**

### 6. 四种隔离级别

数据库提供的4种事务隔离级别：

![1555586275271](https://pic.try-hard.cn/blog/1555586275271.png)

Oracle 支持的 2 种事务隔离级别：**READ COMMITED**, SERIALIZABLE。 Oracle 默认的事务隔离级别为: **READ COMMITED** 。

Mysql 支持 4 种事务隔离级别。Mysql 默认的事务隔离级别为: **REPEATABLE READ。**

### 7. MySQL8 查看和设置隔离级别

每启动一个 MySQL 程序, 就会获得一个单独的数据库连接. 每个数据库连接都有一个全局变量 `transaction_isolation` 表示当前的事务隔离级别。

**查看当前的隔离级别**: 

```mysql
select @@global.transaction_isolation, @@transaction_isolation;
```

**修改全局隔离级别为读提交**：

```mysql
SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

**修改会话隔离级别**:

```mysql
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

## 八、数据库连接池

### 1. JDBC数据库连接池的必要性

在使用开发基于数据库的web程序时，传统的模式基本是按以下步骤：　　

- **在主程序（如servlet、beans）中建立数据库连接**
- **进行sql操作**
- **断开数据库连接**

但是这种模式开发，存在以下问题:

- 普通的JDBC数据库连接使用 DriverManager 来获取，每次向数据库建立连接的时候都要将 Connection 加载到内存中，再验证用户名和密码(得花费0.05s～1s的时间)。需要数据库连接的时候，就向数据库要求一个，执行完成后再断开连接。这样的方式将会消耗大量的资源和时间。**数据库的连接资源并没有得到很好的重复利用。**若同时有几百人甚至几千人在线，频繁的进行数据库连接操作将占用很多的系统资源，严重的甚至会造成服务器的崩溃；
- **对于每一次数据库连接，使用完后都得断开。**否则，如果程序出现异常而未能关闭，将会导致数据库系统中的内存泄漏，最终将导致重启数据库；
- **这种开发不能控制被创建的连接对象数**，系统资源会被毫无顾及的分配出去，如连接过多，也可能导致内存泄漏，服务器崩溃。 

### 2. 数据库连接池技术

为解决传统开发中的数据库连接问题，可以采用数据库连接池技术。

**数据库连接池的基本思想**：就是为数据库连接建立一个“缓冲池”。预先在缓冲池中放入一定数量的连接，当需要建立数据库连接时，只需从“缓冲池”中取出一个，使用完毕之后再放回去。

**数据库连接池**负责分配、管理和释放数据库连接，它**允许应用程序重复使用一个现有的数据库连接，而不是重新建立一个**。数据库连接池在初始化时将创建一定数量的数据库连接放到连接池中，这些数据库连接的数量是由**最小数据库连接数来设定**的。无论这些数据库连接是否被使用，连接池都将一直保证至少拥有这么多的连接数量。连接池的**最大数据库连接数量**限定了这个连接池能占有的最大连接数，当应用程序向连接池请求的连接数超过最大连接数量时，这些请求将被加入到等待队列中。

**数据库连接池工作原理：**

![1555593598606](https://pic.try-hard.cn/blog/1555593598606-1611913490554.png)

**数据库连接池技术的优点**

**1. 资源重用**

由于数据库连接得以重用，避免了频繁创建，释放连接引起的大量性能开销。在减少系统消耗的基础上，另一方面也增加了系统运行环境的平稳性。

**2. 更快的系统反应速度**

数据库连接池在初始化过程中，往往已经创建了若干数据库连接置于连接池中备用。此时连接的初始化工作均已完成。对于业务请求处理而言，直接利用现有可用连接，避免了数据库连接初始化和释放过程的时间开销，从而减少了系统的响应时间。

**3. 新的资源分配手段**

对于多应用共享同一数据库的系统而言，可在应用层通过数据库连接池的配置，实现某一应用最大可用数据库连接数的限制，避免某一应用独占所有的数据库资源。

**4. 统一的连接管理，避免数据库连接泄漏**

在较为完善的数据库连接池实现中，可根据预先的占用超时设定，强制回收被占用连接，从而避免了常规数据库连接操作中可能出现的资源泄露。

### 3. 开源数据库连接池

JDBC 的数据库连接池使用 javax.sql.DataSource 来表示，DataSource 只是一个接口，该接口通常由服务器(Weblogic, WebSphere, Tomcat)提供实现，也有一些开源组织提供实现：

- **DBCP**：是Apache提供的数据库连接池。tomcat 服务器自带dbcp数据库连接池。**速度相对c3p0较快**，但因自身存在 BUG，Hibernate3 已不再提供支持。
- **C3P0**：是一个开源组织提供的一个数据库连接池，**速度相对较慢，稳定性还可以。**hibernate 官方推荐使用；
- **Proxool**：是sourceforge下的一个开源项目数据库连接池，有监控连接池状态的功能，**稳定性较c3p0差一点**；
- **BoneCP**：是一个开源组织提供的数据库连接池，速度快；
- **Druid**：是阿里提供的数据库连接池，据说是集DBCP 、C3P0 、Proxool 优点于一身的数据库连接池，但是速度不确定是否有 BoneCP 快；

- **DataSource**：通常被称为数据源，它包含连接池和连接池管理两个部分，习惯上也经常把 DataSource 称为连接池。**DataSource用来取代DriverManager来获取Connection，获取速度快，同时可以大幅度提高数据库访问速度。**

**注意**：数据源和数据库连接不同，数据源无需创建多个，它是产生数据库连接的工厂，因此**整个应用只需要一个数据源即可。**当数据库访问结束后，程序还是像以前一样关闭数据库连接：conn.close(); 但conn.close()并没有关闭数据库的物理连接，它仅仅把数据库连接释放，归还给了数据库连接池。

#### （1）C3P0数据库连接池

配置文件为：`c3p0-config.xml`

```java
<?xml version="1.0" encoding="UTF-8"?>
<c3p0-config>
	<named-config name="helloc3p0">
		<!-- 获取连接的4个基本信息 -->
		<property name="user">root</property>
		<property name="password">abc123</property>
		<property name="jdbcUrl">jdbc:mysql:///test</property>
		<property name="driverClass">com.mysql.jdbc.Driver</property>
		
		<!-- 涉及到数据库连接池的管理的相关属性的设置 -->
		<!-- 若数据库中连接数不足时, 一次向数据库服务器申请多少个连接 -->
		<property name="acquireIncrement">5</property>
		<!-- 初始化数据库连接池时连接的数量 -->
		<property name="initialPoolSize">5</property>
		<!-- 数据库连接池中的最小的数据库连接数 -->
		<property name="minPoolSize">5</property>
		<!-- 数据库连接池中的最大的数据库连接数 -->
		<property name="maxPoolSize">10</property>
		<!-- C3P0 数据库连接池可以维护的 Statement 的个数 -->
		<property name="maxStatements">20</property>
		<!-- 每个连接同时可以使用的 Statement 对象的个数 -->
		<property name="maxStatementsPerConnection">5</property>

	</named-config>
</c3p0-config>
```

获取连接：

```java
import com.mchange.v2.c3p0.ComboPooledDataSource;

public class Demo {
    public static void main(String[] args) throws Exception {
        DataSource cpds = new ComboPooledDataSource("helloc3p0");
        Connection conn = cpds.getConnection();
        System.out.println(conn);
    }
}
```

#### （2）DBCP数据库连接池

DBCP 是 Apache 软件基金组织下的开源连接池实现，该连接池依赖该组织下的另一个开源系统：Common-pool。如需使用该连接池实现，应在系统中增加如下两个 jar 文件：

- Commons-dbcp.jar：连接池的实现
- Commons-pool.jar：连接池实现的依赖库

**配置属性说明**

| 属性                       | 默认值 | 说明                                                         |
| -------------------------- | ------ | ------------------------------------------------------------ |
| initialSize                | 0      | 连接池启动时创建的初始化连接数量                             |
| maxActive                  | 8      | 连接池中可同时连接的最大的连接数                             |
| maxIdle                    | 8      | 连接池中最大的空闲的连接数，超过的空闲连接将被释放，如果设置为负数表示不限制 |
| minIdle                    | 0      | 连接池中最小的空闲的连接数，低于这个数量会被创建新的连接。该参数越接近maxIdle，性能越好，因为连接的创建和销毁，都是需要消耗资源的；但是不能太大。 |
| maxWait                    | 无限制 | 最大等待时间，当没有可用连接时，连接池等待连接释放的最大时间，超过该时间限制会抛出异常，如果设置-1表示无限等待 |
| poolPreparedStatements     | false  | 开启池的Statement是否prepared                                |
| maxOpenPreparedStatements  | 无限制 | 开启池的prepared 后的同时最大连接数                          |
| minEvictableIdleTimeMillis |        | 连接池中连接，在时间段内一直空闲， 被逐出连接池的时间        |
| removeAbandonedTimeout     | 300    | 超过时间限制，回收没有用(废弃)的连接                         |
| removeAbandoned            | false  | 超过removeAbandonedTimeout时间后，是否进 行没用连接（废弃）的回收 |

配置文件为：`dbcp.properties`

```properties
driverClassName=com.mysql.jdbc.Driver
url=jdbc:mysql://localhost:3306/test?rewriteBatchedStatements=true&useServerPrepStmts=false
username=root
password=abc123

initialSize=10
#...
```

获取连接：

```java
import org.apache.commons.dbcp.BasicDataSourceFactory;

public class Demo {
    public static void main(String[] args) throws Exception {
        DataSource source = null;
        Properties properties = new Properties();
        InputStream is = Demo.class.getClassLoader().getResourceAsStream("dbcp.properties");
        properties.load(is);
        source = BasicDataSourceFactory.createDataSource(properties);
        Connection conn = source.getConnection();
        System.out.println(conn);
    }
}
```

#### （3）Druid（德鲁伊）数据库连接池

Druid 是阿里巴巴开源平台上一个数据库连接池实现，它结合了C3P0、DBCP、Proxool等DB池的优点，同时加入了日志监控，可以很好的监控DB池连接和SQL的执行情况，可以说是针对监控而生的DB连接池，**可以说是目前最好的连接池之一。**

- 详细配置参数：

| **配置**                      | **缺省** | **说明**                                                     |
| ----------------------------- | -------- | ------------------------------------------------------------ |
| name                          |          | 配置这个属性的意义在于，如果存在多个数据源，监控的时候可以通过名字来区分开来。   如果没有配置，将会生成一个名字，格式是：”DataSource-” +   System.identityHashCode(this) |
| url                           |          | 连接数据库的url，不同数据库不一样。例如：mysql :   jdbc:mysql://10.20.153.104:3306/druid2      oracle :   jdbc:oracle:thin:@10.20.149.85:1521:ocnauto |
| username                      |          | 连接数据库的用户名                                           |
| password                      |          | 连接数据库的密码。如果你不希望密码直接写在配置文件中，可以使用ConfigFilter。详细看这里：<https://github.com/alibaba/druid/wiki/%E4%BD%BF%E7%94%A8ConfigFilter> |
| driverClassName               |          | 根据url自动识别   这一项可配可不配，如果不配置druid会根据url自动识别dbType，然后选择相应的driverClassName(建议配置下) |
| initialSize                   | 0        | 初始化时建立物理连接的个数。初始化发生在显示调用init方法，或者第一次getConnection时 |
| maxActive                     | 8        | 最大连接池数量                                               |
| maxIdle                       | 8        | 已经不再使用，配置了也没效果                                 |
| minIdle                       |          | 最小连接池数量                                               |
| maxWait                       |          | 获取连接时最大等待时间，单位毫秒。配置了maxWait之后，缺省启用公平锁，并发效率会有所下降，如果需要可以通过配置useUnfairLock属性为true使用非公平锁。 |
| poolPreparedStatements        | false    | 是否缓存preparedStatement，也就是PSCache。PSCache对支持游标的数据库性能提升巨大，比如说oracle。在mysql下建议关闭。 |
| maxOpenPreparedStatements     | -1       | 要启用PSCache，必须配置大于0，当大于0时，poolPreparedStatements自动触发修改为true。在Druid中，不会存在Oracle下PSCache占用内存过多的问题，可以把这个数值配置大一些，比如说100 |
| validationQuery               |          | 用来检测连接是否有效的sql，要求是一个查询语句。如果validationQuery为null，testOnBorrow、testOnReturn、testWhileIdle都不会其作用。 |
| testOnBorrow                  | true     | 申请连接时执行validationQuery检测连接是否有效，做了这个配置会降低性能。 |
| testOnReturn                  | false    | 归还连接时执行validationQuery检测连接是否有效，做了这个配置会降低性能 |
| testWhileIdle                 | false    | 建议配置为true，不影响性能，并且保证安全性。申请连接的时候检测，如果空闲时间大于timeBetweenEvictionRunsMillis，执行validationQuery检测连接是否有效。 |
| timeBetweenEvictionRunsMillis |          | 有两个含义： 1)Destroy线程会检测连接的间隔时间2)testWhileIdle的判断依据，详细看testWhileIdle属性的说明 |
| numTestsPerEvictionRun        |          | 不再使用，一个DruidDataSource只支持一个EvictionRun           |
| minEvictableIdleTimeMillis    |          |                                                              |
| connectionInitSqls            |          | 物理连接初始化的时候执行的sql                                |
| exceptionSorter               |          | 根据dbType自动识别   当数据库抛出一些不可恢复的异常时，抛弃连接 |
| filters                       |          | 属性类型是字符串，通过别名的方式配置扩展插件，常用的插件有：   监控统计用的filter:stat日志用的filter:log4j防御sql注入的filter:wall |
| proxyFilters                  |          | 类型是List，如果同时配置了filters和proxyFilters，是组合关系，并非替换关 |

配置文件为：`druid.properties`

```properties
url=jdbc:mysql://localhost:3306/test?rewriteBatchedStatements=true
username=root
password=123456
driverClassName=com.mysql.jdbc.Driver

initialSize=10
maxActive=20
maxWait=1000
filters=wall
```

获取连接：

```java
import com.alibaba.druid.pool.DruidDataSourceFactory;

public class Demo {
    public static void main(String[] args) throws Exception {
        DataSource source = null;
        Properties properties = new Properties();
        properties.load(Demo.class.getClassLoader().getResourceAsStream("druid.properties"));
        source = DruidDataSourceFactory.createDataSource(properties);
        Connection conn = source.getConnection();
        System.out.println(conn);
    }
}
```

## 九、Apache-DBUtils实现CRUD操作

### 1. Apache-DBUtils简介

`commons-dbutils`是 Apache 组织提供的一个开源 JDBC工具类库，它是对JDBC的简单封装，学习成本极低，并且使用dbutils能极大简化jdbc编码的工作量，同时也不会影响程序的性能。

- API介绍：
  - org.apache.commons.dbutils.QueryRunner
  - org.apache.commons.dbutils.ResultSetHandler
  - 工具类：org.apache.commons.dbutils.DbUtils   

### 2. 主要API的使用

#### （1） DbUtils

DbUtils ：提供如关闭连接、装载JDBC驱动程序等常规工作的工具类，里面的所有方法都是静态的。主要方法如下：

- `public static void close(…) throws java.sql.SQLException`：DbUtils类提供了三个重载的关闭方法。这些方法检查所提供的参数是不是NULL，如果不是的话，它们就关闭Connection、Statement和ResultSet。
- `public static void closeQuietly(…)`: 这一类方法不仅能在Connection、Statement和ResultSet为NULL情况下避免关闭，还能隐藏一些在程序中抛出的SQLEeception。
- `public static void commitAndClose(Connection conn)throws SQLException`：用来提交连接的事务，然后关闭连接
- `public static void commitAndCloseQuietly(Connection conn)`：用来提交连接，然后关闭连接，并且在关闭连接时不抛出SQL异常。 
- `public static void rollback(Connection conn)throws SQLException`：允许conn为null，因为方法内部做了判断
- `public static void rollbackAndClose(Connection conn)throws SQLException`
- `rollbackAndCloseQuietly(Connection)`
- `public static boolean loadDriver(java.lang.String driverClassName)`：这一方装载并注册JDBC驱动程序，如果成功就返回true。使用该方法，你不需要捕捉这个异常ClassNotFoundException。

#### （2）QueryRunner类

**该类简单化了SQL查询，它与ResultSetHandler组合在一起使用可以完成大部分的数据库操作，能够大大减少编码量。**

QueryRunner类提供了两个构造器：

- 默认的构造器
- 需要一个 javax.sql.DataSource 来作参数的构造器

QueryRunner类的主要方法：

- **更新**
  - `public int update(Connection conn, String sql, Object... params) throws SQLException`：用来执行一个更新（插入、更新或删除）操作。
- **插入**
  - `public <T> T insert(Connection conn,String sql,ResultSetHandler<T> rsh, Object... params) throws SQLException`：只支持INSERT语句，其中 rsh - The handler used to create the result object from the ResultSet of auto-generated keys.  返回值: An object generated by the handler.即自动生成的键值
- **批处理**
  - `public int[] batch(Connection conn,String sql,Object[][] params)throws SQLException`： INSERT, UPDATE, or DELETE语句
  - `public <T> T insertBatch(Connection conn,String sql,ResultSetHandler<T> rsh,Object[][] params)throws SQLException`：只支持INSERT语句
- **查询**
  - `public Object query(Connection conn, String sql, ResultSetHandler rsh,Object... params) throws SQLException`：执行一个查询操作，在这个查询中，对象数组中的每个元素值被用来作为查询语句的置换参数。该方法会自行处理 PreparedStatement 和 ResultSet 的创建和关闭。

