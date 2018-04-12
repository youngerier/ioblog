DECLARE @@Need INT
SET @@Need = (
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
    case when @@Need> 0 then 1 else 0 end AS NeedUpdate
FROM
    Learn_AppInfo a with(nolock)
WHERE
    systemtype = @systemtype
AND isdeleted = 0
ORDER BY version DESC