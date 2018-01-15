---
title: csharp
date: 2018-01-15 14:25:59
tags:
    - cshrap
---


```c#
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