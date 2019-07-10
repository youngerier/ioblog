---
title: sql调优
date: 2018-03-16 16:49:29
tags:
---


### 连接优化
```sql
  --before
  SELECT
  *
  FROM
  (
    SELECT
    TOP 15 *
    FROM
    zbjm_comment WITH (nolock)
    WHERE
    AuditStatus = 1
    AND IsDeleted = 0
    AND path LIKE '1:0000000000000000059-0000000000000107656%'
    ORDER BY
    Id
  ) a0
  UNION ALL
   SELECT
            *
            FROM
            (
              SELECT
              TOP 15 *
              FROM
              zbjm_comment WITH (nolock)
              WHERE
              AuditStatus = 1
              AND IsDeleted = 0
              AND path LIKE '1:0000000000000000059-0000000000000003369%'
              ORDER BY
              Id
            ) a10
  -- after 

  DECLARE @@temp TABLE (path VARCHAR(MAX)) INSERT INTO @@temp
  VALUES ('1:0000000000000000059-0000000000000107656%'),
    ('1:0000000000000000059-0000000000000087470%'),
    ('1:0000000000000000059-0000000000000040167%'),
    ('1:0000000000000000059-0000000000000004254%'),
   
    ('1:0000000000000000059-0000000000000003377%'),
    ('1:0000000000000000059-0000000000000003369%') 
      SELECT
      c.[Id],
      c.[UserId],
      c.[NickName],
      c.[Avatar],
      c.[TargetType],
      c.[TargetId],
      c.[Path],
      c.[CommentContent],
      c.[AuditStatus],
      c.[PraiseCount],
      c.[CreationTime],
      c.[ModificationTime],
      c.[IsDeleted]
    FROM
      zbjm_comment c WITH (
        nolock,
        INDEX = [NonClusteredIndex-Path]
      )
    JOIN @@temp t ON c.path LIKE t.path   -- 此处c 表path 建立非聚集索引
    WHERE
      c.auditstatus = 1
    AND c.isdeleted = 0
      
  ```

### 插入时去重 insert 

  ```sql
  INSERT INTO dbo.Learn_CouponSendJob (
    UserId,
    NickName,
    AddTime,
    IsDeleted,
    SendId,
    CouponId,
    IsNotice,
    SendTime,
    SendStatus,
    SendToId
  ) SELECT
    t1.*
  FROM
    (
      SELECT
        Id AS UserId,
        NickName AS NickName,
        GetDate() AS AddTime,
        0 AS IsDeleted,
        43 AS SendId,
        3 AS CouponId,
        0 AS IsNotice ,GETDATE() AS SendTime,
        1 AS SendStatus ,- 1 AS SendToId
      FROM
        Learn_User WITH (NOLOCK)
      WHERE
        Status = 1
      AND Id IN (152)
    ) t1
  LEFT JOIN dbo.Learn_CouponSendJob t2 ON t1.UserId = t2.UserId
  AND t1.SendId = t2.SendId
  AND t1.SendToId = t2.SendToId
  WHERE
    t2.id IS NULL
```
<!-- more -->

###  查询父表数据并 统计子表中的数量
```sql
  SELECT
    ROW_NUMBER () OVER (ORDER BY MAX(eg.addtime)) RowNum,
    MAX (eg.title) title,
    MAX (eg.id) id,
    MAX (eg.ProductType) productType,
    MAX (eg.ProductId) productId,
    MAX (eg.addtime) addtime,
    MAX (eg.begintime) begintime,
    MAX (eg.endtime) endtime,
    MAX (eg.total) total,
    MAX (eg.status) status,
    COUNT (e.GroupId) GetNum,
    CASE WHEN COUNT (e.GroupId) = MAX(eg.total)  THEN	1 ELSE 0 end IsGen

  FROM
    Learn_exchangeGroup eg WITH (nolock)
  LEFT JOIN Learn_exchange e WITH (nolock) ON e.GroupId = eg.id
  group by eg.id
```


### 对版本软件版本管理
当前版本和最新之间的版本是否包含强制更新
```sql
  DECLARE @Need INT
  SET @Need = (
    SELECT
      COUNT (1) AS c
    FROM
      Learn_AppInfo WITH (nolock)
    WHERE
      version >=@version
    AND Needupdate = 1
    AND isdeleted = 0
  ) 
  SELECT
    TOP 1 a.Version,
    a.title,
    a.content,
    a.systemtype,
    a.url,
    a.auditstatus,
    case when @Need> 0 then 1 else 0 end AS NeedUpdate
  FROM
    Learn_AppInfo a
  WHERE
    systemtype = 1
  AND isdeleted = 0
  ORDER BY version DESC
```