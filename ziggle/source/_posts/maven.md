---
title: maven
date: 2018-01-15 12:44:29
tags:
    - maven
---

#### pom模板文件
```xml
<?xml version="1.0"?>

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
<!-- 模型版本。maven2.0必须是这样写，现在是maven2唯一支持的版本 -->  
    <modelVersion>4.0.0</modelVersion>
    <!-- 公司或者组织的唯一标志，并且配置时生成的路径也是由此生成， 如com.winner.trade，maven会将该项目打成的jar包放本地路径：/com/winner/trade -->  
    <groupId>temp.download</groupId>
     <!-- 本项目的唯一ID，一个groupId下面可能多个项目，就是靠artifactId来区分的 -->  
    <artifactId>temp-download</artifactId>
    <version>1.0-SNAPSHOT</version> 
    <!-- 打包的机制，如pom,jar, maven-plugin, ejb, war, ear, rar, par，默认为jar -->  
    <packaging>jar</packaging>
    <dependencies>
    <!-- 需要下载什么jar包 添加相应依赖 其余部分无需在意-->
        <dependency>
            <groupId>org.apache.httpcomponents</groupId>
            <artifactId>httpcore</artifactId>
            <version>4.3.1</version>
            <!-- 设置指依赖是否可选，默认为false,即子项目默认都继承:为true,则子项目必需显示的引入，与dependencyManagement里定义的依赖类似  -->  
            <optional></optional>
        </dependency>
    </dependencies>

        <!-- 为pom定义一些常量，在pom中的其它地方可以直接引用 使用方式 如下 ：${file.encoding} -->  
    <properties>  
        <file.encoding>UTF-8</file.encoding>  
        <java.source.version>1.5</java.source.version>  
        <java.target.version>1.5</java.target.version>  
    </properties>  
</project>
```

### 构建配置
```xml
<build>

	<!-- 产生的构件的文件名，默认值是${artifactId}-${version}。 -->
	<finalName>myPorjectName</finalName>

	<!-- 构建产生的所有文件存放的目录,默认为${basedir}/target，即项目根目录下的target -->
	<directory>${basedir}/target</directory>

	<!--当项目没有规定目标（Maven2叫做阶段（phase））时的默认值， -->
	<!--必须跟命令行上的参数相同例如jar:jar，或者与某个阶段（phase）相同例如install、compile等 -->
	<defaultGoal>install</defaultGoal>

	<!--当filtering开关打开时，使用到的过滤器属性文件列表。 -->
	<!--项目配置信息中诸如${spring.version}之类的占位符会被属性文件中的实际值替换掉 -->
	<filters>
		<filter>../filter.properties</filter>
	</filters>

	<!--项目相关的所有资源路径列表，例如和项目相关的配置文件、属性文件，这些资源被包含在最终的打包文件里。 -->
	<resources>
		<resource>

			<!--描述了资源的目标路径。该路径相对target/classes目录（例如${project.build.outputDirectory}）。 -->
			<!--举个例子，如果你想资源在特定的包里(org.apache.maven.messages)，你就必须该元素设置为org/apache/maven/messages。 -->
			<!--然而，如果你只是想把资源放到源码目录结构里，就不需要该配置。 -->
			<targetPath>resources</targetPath>

			<!--是否使用参数值代替参数名。参数值取自properties元素或者文件里配置的属性，文件在filters元素里列出。 -->
			<filtering>true</filtering>

			<!--描述存放资源的目录，该路径相对POM路径 -->
			<directory>src/main/resources</directory>

			<!--包含的模式列表 -->
			<includes>
				<include>**/*.properties</include>
				<include>**/*.xml</include>
			</includes>

			<!--排除的模式列表 如果<include>与<exclude>划定的范围存在冲突，以<exclude>为准 -->
			<excludes>
				<exclude>jdbc.properties</exclude>
			</excludes>

		</resource>
	</resources>

	<!--单元测试相关的所有资源路径，配制方法与resources类似 -->
	<testResources>
		<testResource>
			<targetPath />
			<filtering />
			<directory />
			<includes />
			<excludes />
		</testResource>
	</testResources>

	<!--项目源码目录，当构建项目的时候，构建系统会编译目录里的源码。该路径是相对于pom.xml的相对路径。 -->
	<sourceDirectory>${basedir}\src\main\java</sourceDirectory>

	<!--项目脚本源码目录，该目录和源码目录不同， <!-- 绝大多数情况下，该目录下的内容会被拷贝到输出目录(因为脚本是被解释的，而不是被编译的)。 -->
	<scriptSourceDirectory>${basedir}\src\main\scripts
	</scriptSourceDirectory>

	<!--项目单元测试使用的源码目录，当测试项目的时候，构建系统会编译目录里的源码。该路径是相对于pom.xml的相对路径。 -->
	<testSourceDirectory>${basedir}\src\test\java</testSourceDirectory>

	<!--被编译过的应用程序class文件存放的目录。 -->
	<outputDirectory>${basedir}\target\classes</outputDirectory>

	<!--被编译过的测试class文件存放的目录。 -->
	<testOutputDirectory>${basedir}\target\test-classes
	</testOutputDirectory>

	<!--项目的一系列构建扩展,它们是一系列build过程中要使用的产品，会包含在running bulid‘s classpath里面。 -->
	<!--他们可以开启extensions，也可以通过提供条件来激活plugins。 -->
	<!--简单来讲，extensions是在build过程被激活的产品 -->
	<extensions>

		<!--例如，通常情况下，程序开发完成后部署到线上Linux服务器，可能需要经历打包、 -->
		<!--将包文件传到服务器、SSH连上服务器、敲命令启动程序等一系列繁琐的步骤。 -->
		<!--实际上这些步骤都可以通过Maven的一个插件 wagon-maven-plugin 来自动完成 -->
		<!--下面的扩展插件wagon-ssh用于通过SSH的方式连接远程服务器， -->
		<!--类似的还有支持ftp方式的wagon-ftp插件 -->
		<extension>
			<groupId>org.apache.maven.wagon</groupId>
			<artifactId>wagon-ssh</artifactId>
			<version>2.8</version>
		</extension>

	</extensions>

	<!--使用的插件列表 。 -->
	<plugins>
		<plugin>
			<groupId></groupId>
			<artifactId>maven-assembly-plugin</artifactId>
			<version>2.5.5</version>

			<!--在构建生命周期中执行一组目标的配置。每个目标可能有不同的配置。 -->
			<executions>
				<execution>

					<!--执行目标的标识符，用于标识构建过程中的目标，或者匹配继承过程中需要合并的执行目标 -->
					<id>assembly</id>

					<!--绑定了目标的构建生命周期阶段，如果省略，目标会被绑定到源数据里配置的默认阶段 -->
					<phase>package</phase>

					<!--配置的执行目标 -->
					<goals>
						<goal>single</goal>
					</goals>

					<!--配置是否被传播到子POM -->
					<inherited>false</inherited>

				</execution>
			</executions>

			<!--作为DOM对象的配置,配置项因插件而异 -->
			<configuration>
				<finalName>${finalName}</finalName>
				<appendAssemblyId>false</appendAssemblyId>
				<descriptor>assembly.xml</descriptor>
			</configuration>

			<!--是否从该插件下载Maven扩展（例如打包和类型处理器）， -->
			<!--由于性能原因，只有在真需要下载时，该元素才被设置成true。 -->
			<extensions>false</extensions>

			<!--项目引入插件所需要的额外依赖 -->
			<dependencies>
				<dependency>...</dependency>
			</dependencies>

			<!--任何配置是否被传播到子项目 -->
			<inherited>true</inherited>

		</plugin>
	</plugins>

	<!--主要定义插件的共同元素、扩展元素集合，类似于dependencyManagement， -->
	<!--所有继承于此项目的子项目都能使用。该插件配置项直到被引用时才会被解析或绑定到生命周期。 -->
	<!--给定插件的任何本地配置都会覆盖这里的配置 -->
	<pluginManagement>
		<plugins>...</plugins>
	</pluginManagement>

</build>
```
### 使用mvn 生成模板项目
```sh
ziggle@ziggle MINGW64 /e/code/mvnjava
$  mvn archetype:generate -DgroupId=com.zigglle -DartifactId=mymvn
```


### 在应用程序用使用多个存储库
```xml
    <repositories>    
    <repository>      
       <id>Ibiblio</id>      
       <name>Ibiblio</name>      
       <url>http://www.ibiblio.org/maven/</url>    
    </repository>    
    <repository>      
       <id>PlanetMirror</id>      
       <name>Planet Mirror</name>      
       <url>http://public.planetmirror.com/pub/maven/</url>    
    </repository> 
    </repositories>
```
### 依赖scope

- compile：编译依赖范围，在编译，测试，运行时都需要，依赖范围默认值
- test：测试依赖范围，测试时需要。编译和运行不需要，如junit
- provided：已提供依赖范围，编译和测试时需要。运行时不需要,如servlet-api
- runtime：运行时依赖范围，测试和运行时需要。编译不需要,例如面向接口编程，JDBC驱动实现jar
- system：系统依赖范围。本地依赖，不在maven中央仓库，结合systemPath标签使用

### 依赖排除
使用`<exclusions>`标签下的`<exclusion>`标签指定GA信息来排除，例如：排除xxx.jar传递依赖过来的yyy.jar

```xml
<dependency>
  <groupId>com.xxx</groupId>
  <artifactId>xxx</artifactId>
  <version>x.version</version>
  <exclusions>
    <exclusion>
      <groupId>com.xxx</groupId>
      <artifactId>yyy</artifactId>
    </exclusion>
  </exclusions>
</dependency>
```

### maven 依赖包-SNAPSHOT / release
如果在一个项目中，我们依赖了模块A的快照版，还依赖了模块B的正式版本，那么在不更改依赖模块版本号的情况下，我们在进行直接编译打包该项目时：即使本地仓库中已经存在对应版本的依赖模块A，maven还是会自动从镜像服务器上下载最新的依赖模块A的快照版本。而依赖正式版本的模块B，如果本地仓库已经存在该版本的模块B, maven则不会主动去镜像服务器上下载。这也是为什么我们会在本地仓库中快照版本的依赖的目录下会看到带有时间戳的jar包
> 解决方法

```
mvn clean install -U
```
或者修改本地mvn配置文件的私服配置

```xml
    <profile>
        <id>nexus</id>
        <repositories>
            <repository>
                <id>nexus</id>
                <name>Nexus</name>
                <url>http://localhost:8087/nexus/content/groups/public/</url>
                <releases>
                    <enabled>true</enabled>
                    <updatePolicy>always</updatePolicy>
                </releases>
                <snapshots>
                    <enabled>true</enabled>
                    <updatePolicy>always</updatePolicy>
                </snapshots>
            </repository>
        </repositories>
        <pluginRepositories>
            <pluginRepository>
                <id>nexus</id>
                <name>Nexus</name>
                <url>http://localhost:8087/nexus/content/groups/public/</url>
                <releases>
                    <enabled>true</enabled>
                    <updatePolicy>always</updatePolicy>
                </releases>
                <snapshots>
                    <enabled>true</enabled>
                    <updatePolicy>always</updatePolicy>
                </snapshots>
            </pluginRepository>
        </pluginRepositories>
    </profile>
```

### mvn 构建项目
```
mvn archetype:generate 
mvn archetype:gennerate -Dgroupid=公司网址反写+项目名 -DartifactId=项目名-模块名 -Dversion=版本号 -Dpackage=代码所在的包
```

### 设置maven 平台编码

- win
```cmd
set "MAVEN_OPTS=-Duser.language=en -Dfile.encoding=UTF-8"
```

- linux

```sh
export MAVEN_OPTS='-Duser.language=en -Dfile.encoding=UTF-8'
```