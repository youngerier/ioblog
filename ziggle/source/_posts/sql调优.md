---
title: sql调优
date: 2018-03-16 16:49:29
tags:
---

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
   AND path LIKE '1:0000000000000000059-0000000000000087470%'
   ORDER BY
    Id
  ) a1
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
    AND path LIKE '1:0000000000000000059-0000000000000040167%'
    ORDER BY
     Id
   ) a2
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
     AND path LIKE '1:0000000000000000059-0000000000000004254%'
     ORDER BY
      Id
    ) a3
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
      AND path LIKE '1:0000000000000000059-0000000000000003760%'
      ORDER BY
       Id
     ) a4
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
       AND path LIKE '1:0000000000000000059-0000000000000003462%'
       ORDER BY
        Id
      ) a5
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
        AND path LIKE '1:0000000000000000059-0000000000000003452%'
        ORDER BY
         Id
       ) a6
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
         AND path LIKE '1:0000000000000000059-0000000000000003451%'
         ORDER BY
          Id
        ) a7
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
          AND path LIKE '1:0000000000000000059-0000000000000003385%'
          ORDER BY
           Id
         ) a8
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
           AND path LIKE '1:0000000000000000059-0000000000000003377%'
           ORDER BY
            Id
          ) a9
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
	('1:0000000000000000059-0000000000000003760%'),
	('1:0000000000000000059-0000000000000003462%'),
	('1:0000000000000000059-0000000000000003452%'),
	('1:0000000000000000059-0000000000000003451%'),
	('1:0000000000000000059-0000000000000003385%'),
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

> 去重 insert 
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