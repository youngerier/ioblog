public class Test{

    public static void main(String[] arg){

      ClassLoader c  = Test.class.getClassLoader();  //获取Test类的类加载器

        System.out.println(c); 

      ClassLoader c1 = c.getParent();  //获取c这个类加载器的父类加载器

        System.out.println(c1);

      ClassLoader c2 = c1.getParent();//获取c1这个类加载器的父类加载器

        System.out.println(c2);

  }

}

/**
sun.misc.Launcher$AppClassLoader@73d16e93
sun.misc.Launcher$ExtClassLoader@15db9742
null
 */