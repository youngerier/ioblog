---
title: csharp
date: 2018-01-15 14:25:59
tags:
    - cshrap
---


```csharp
 /// <summary>  
        ///  实体类序列化成xml  
        /// </summary>  
        /// <param name="enitities">实体.</param>  
        /// <param name="headtag">节点名称 (实体类名)</param>  
        /// <returns></returns> 
        public static string ObjListToXml<T>(List<T> enitities, string headtag)
        {
            StringBuilder sb = new StringBuilder();
            PropertyInfo[] propinfos = null;
            //sb.AppendLine("<?xml version=\"1.0\" encoding=\"utf-8\"?>");  
            sb.AppendLine("<" + headtag + ">");
            foreach (T obj in enitities)
            {
                //初始化propertyinfo  
                if (propinfos == null)
                {
                    Type objtype = obj.GetType();
                    if (objtype != typeof(string) && objtype != typeof(int))
                    {
                        propinfos = objtype.GetProperties();
                    }
                }
                sb.AppendLine("<item>");
                if (propinfos != null)
                {
                    foreach (PropertyInfo propinfo in propinfos)
                    {
                        var value = propinfo.GetValue(obj, null);
                        sb.Append("<");
                        sb.Append(propinfo.Name);
                        sb.Append(">");
                        sb.Append(value ?? "");
                        sb.Append("</");
                        sb.Append(propinfo.Name);
                        sb.AppendLine(">");
                    }
                }
                else
                {
                    var value = obj;
                    sb.Append("<i>");
                    sb.Append(value);
                    sb.Append("</i>");
                }
                sb.AppendLine("</item>");
            }
            sb.AppendLine("</" + headtag + ">");
            return sb.ToString();
        }
```

### Multiple Active Result Sets (MARS)

多个活动结果集 (MARS) 是一项用于 SQL Server 的功能，可用来对单个连接执行多个批处理。 如果对 SQL Server 启用了 MARS，使用的每个命令对象将向该连接添加一个会话。

```c#
string connectionString = "Data Source=MSSQL1;" +
    "Initial Catalog=AdventureWorks;Integrated Security=SSPI;" +  
    "MultipleActiveResultSets=True";
```
