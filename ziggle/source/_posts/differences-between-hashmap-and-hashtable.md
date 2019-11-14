---
title: differences_between_hashmap_and_hashtable
date: 2018-04-08 17:47:35
tags:
    - hashmap hashtable 的不同
---
> 线程
hashtable 是同步的 相反 hashmap并不是,
> null
hashtable 不允许有**null**key 或value ,hashmap 运行有一个null key 和任意个null value
> iterator
hashmap的子类linkedhashmap 迭代出的元素按插入顺序 可以有hashmap -> linkedhashmap 获取有序遍历


### 为什么使用char[] 保存password 而不是 String

string 类型是不可变类型,当创建String 实例对象,如果另一个进程dump 内存,是没法清除创建的string (在gc介入之前),如果用char[] 可以显式wrap数据
减少了password 被attack ....

### java concurrent 包实现
线程间通信有四种方式
A线程写volatile变量，随后B线程读这个volatile变量。
A线程写volatile变量，随后B线程用CAS更新这个volatile变量。
A线程用CAS更新一个volatile变量，随后B线程用CAS更新这个volatile变量。
A线程用CAS更新一个volatile变量，随后B线程读这个volatile变量。

volatile变量的读/写和CAS可以实现线程之间的通信 => **java concurrent包的基石** 

{% asset_img concurrent.png concurrent%}


###  分析HashMap的put方法 

①.判断键值对数组 table[i] 是否为空或为 null，否则执行 resize() 进行扩容；

②.根据键值 key 计算 hash 值得到插入的数组索引i，如果 table[i]==null，直接新建节点添加，转向 ⑥，如果table[i] 不为空，转向 ③；

③.判断 table[i] 的首个元素是否和 key 一样，如果相同直接覆盖 value，否则转向 ④，这里的相同指的是 hashCode 以及 equals；

④.判断table[i] 是否为 treeNode，即 table[i] 是否是红黑树，如果是红黑树，则直接在树中插入键值对，否则转向 ⑤；

⑤.遍历 table[i]，判断链表长度是否大于 8，大于 8 的话把链表转换为红黑树，在红黑树中执行插入操作，否则进行链表的插入操作；遍历过程中若发现 key 已经存在直接覆盖 value 即可；

⑥.插入成功后，判断实际存在的键值对数量 size 是否超多了最大容量 threshold，如果超过，进行扩容。


{% asset_img hashmap-put.png hashmap-put%}


```java
public V put(K key, V value) {
    // 对key的hashCode()做hash
    return putVal(hash(key), key, value, false, true);
}

final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
               boolean evict) {
    Node<K,V>[] tab; Node<K,V> p; int n, i;
    // 步骤①：tab为空则创建
    if ((tab = table) == null || (n = tab.length) == 0)
        n = (tab = resize()).length;
    // 步骤②：计算index，并对null做处理 
    if ((p = tab[i = (n - 1) & hash]) == null) 
        tab[i] = newNode(hash, key, value, null);
    else {
        Node<K,V> e; K k;
        // 步骤③：节点key存在，直接覆盖value
        if (p.hash == hash &&
            ((k = p.key) == key || (key != null && key.equals(k))))
            e = p;
        // 步骤④：判断该链为红黑树
        else if (p instanceof TreeNode)
            e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
        // 步骤⑤：该链为链表
        else {
            for (int binCount = 0; ; ++binCount) {
                if ((e = p.next) == null) {
                    p.next = newNode(hash, key,value,null);
                     //链表长度大于8转换为红黑树进行处理
                    if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st  
                        treeifyBin(tab, hash);
                    break;
                }
                 // key已经存在直接覆盖value
                if (e.hash == hash &&
                    ((k = e.key) == key || (key != null && key.equals(k)))) 
                           break;
                p = e;
            }
        }
        
        if (e != null) { // existing mapping for key
            V oldValue = e.value;
            if (!onlyIfAbsent || oldValue == null)
                e.value = value;
            afterNodeAccess(e);
            return oldValue;
        }
    }
    ++modCount;
    // 步骤⑥：超过最大容量 就扩容
    if (++size > threshold)
        resize();
    afterNodeInsertion(evict);
    return null;
}
```