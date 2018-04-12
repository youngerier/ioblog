场景：假设数据库中有一个商品表中存储了1000万条记录，ID是递增但不连续的，现在按照一个排序值字段进行倒序排列，分页（分段）查询商品列表，使用Redis作为查询缓存层。

问题：何保证数据更新及时到位？比如更新商品价格。

解决方案：

假设查询接口涉及分页的参数是：

int skip 跳过多少行

int take 获取多少条记录

使用两个缓存数据结构，分别是 Redis 的 Lists 和 Hashes。


查询流程

当第一次查询无数据时，查询课程分页第一页缓存 course_page_ids_0_10 ，skip = 0， take = 10。
此时缓存不存在，通过查询数据库获得数据，假设获取到的列表对应的 id 信息是 1,10,2000,9999,10000,20001,20002,20003,20004,40005。
则直接把主键信息写入到
course_page_ids_0_10 （存储的是 1,10,2000,9999,10000,20001,20002,20003,20004,40005），设置缓存时间假设是 5 分钟
且同时把这些数据写入到 设置缓存时间 假设是 1分钟
course_1_10000 （存储的是 1,10,2000,9999,10000 这5条数据）
course_10001_20000 （存储的是 20001,20002,20003,20004 这4条数据）
course_40001_50000 （存储的是 40005 这1条数据）
当第二次查询第一页的数据时，假设 “缓存分页主键”信息没有过期，并且“缓存表结构数据”已过期。
相当于已知第一页数据对应的ID为 1,10,2000,9999,10000,20001,20002,20003,20004,40005。
course_1_10000、course_10001_20000 、course_40001_50000 获取数据均未获取到或部分未获取到。
则直接通过数据库查询未从缓存中查询到数据实体信息，查询到之后按照第1步中类似的步骤写入缓存。
如果是查询分页还有其他参数，则可以调整 “缓存分页主键” 的缓存键
比如 course_order_asc_page_ids_0_10、course_order_desc_page_ids_0_10、course_addtime_asc_page_ids_0_10、course_addtime_desc_page_ids_0_10。
更新流程

更新课程编号1的缓存信息，则直接将课程1的缓存信息更新到 course_1_10000 

注意：
以上key的命名仅作举例参考，具体可以自行调整。
特别强调仅对数据及时性要求非常严格的地方可以考虑采用本方案，比如产品列表对应有价格更新，一般情况可以考虑缩短缓存时间或允许脏读，具体根据业务来定。








执行以下两个版本（x86/x64）的 最大并发数设置

C:\Windows\System32\inetsrv\appcmd.exe set config /section:system.webserver/serverRuntime /appConcurrentRequestLimit:100000
C:\Windows\SysWow64\inetsrv\appcmd.exe set config /section:system.webserver/serverRuntime /appConcurrentRequestLimit:100000


第二项
C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet.config
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\aspnet.config
参考以下的值，主要设置 maxConcurrentRequestsPerCPU

aspnet.config
<?xml version="1.0" encoding="UTF-8" ?>
<configuration>
    <runtime>
        <legacyUnhandledExceptionPolicy enabled="false" />
        <legacyImpersonationPolicy enabled="true"/>
        <alwaysFlowImpersonationPolicy enabled="false"/>
        <SymbolReadingPolicy enabled="1" />
        <shadowCopyVerifyByTimestamp enabled="true"/>
    </runtime>
    <startup useLegacyV2RuntimeActivationPolicy="true" />
    <system.web>
        <applicationPool maxConcurrentRequestsPerCPU="20000" />
    </system.web>
</configuration>


第三项 
C:\Windows\Microsoft.NET\Framework\v4.0.30319\Config\machine.config
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config
大约在250行

250
<processModel autoConfig="false" requestQueueLimit="250000" />