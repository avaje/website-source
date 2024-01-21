<h2 id="aop">Aspect Oriented Programming</h3>
This library has several contructs that support Aspect Oriented Programmming

<h3 id="aspect">@Aspect</h3>
<p>
  Create an annotation class and annotate it with <code>@Aspect</code> to define an aspect annotation.
  To control the execution order of multiple aspects, we can use the ordering property of the <code>@Aspect</code>.
  To import an existing annotation, use <code>@Aspect.Import</code>.
</p>
<pre content="java">
@Aspect(ordering=1) // Determines priority among other aspects
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface MyAround {

  String name() default "";
}
</pre>

<p>
For this aspect to work, a corresponding AspectProvider must be wired into the scope.
The AspectProvider should be a <code>@Singleton</code> or <code>@Component</code> that provides a <code>MethodInterceptor</code>.
 (Which will intercept the method call).
</p>

<pre content="java">
@Singleton
public class MyAroundAspect implements AspectProvider<MyAround> {

  @Override
  public MethodInterceptor interceptor(Method method, MyAround around) {
    return new ExampleInterceptor();
  }

  static class ExampleInterceptor implements MethodInterceptor {
    // MethodInterceptor interception method
    @Override
    public void invoke(Invocation invoke) throws Throwable {
      System.out.println("before args: " + Arrays.toString(invoke.arguments()) + " method: " + invoke.method());
      try {
        invoke.invoke();
      } finally {
        System.out.println("after");
      }
    }
  }
}
</pre>

<p>
With the provider set, we can use our newly created aspect annotation on a class/method to intercept calls.
</p>

<pre content="java">
@Singleton
public class ExampleService {

  @MyAround
  public String example(
      String param0, int param1) {
    return "other " + param0 + " " + param1;
  }
}
</pre>

<p>
  Avaje will generate a proxy class that will run the aspects for every annotated method.
</p>
<pre content="java">
@Proxy
@Generated("io.avaje.inject.generator")
public class ExampleService$Proxy extends ExampleService {

  private final MyAroundAspect myAroundAspect;

  private Method example0;
  private MethodInterceptor example0MyAround;

  public ExampleService$Proxy(MyAroundAspect myAroundAspect) {
    super();
    this.myAroundAspect = myAroundAspect;
    try {
      example0 = ExampleService.class.getDeclaredMethod("example", String.class, int.class);
      example0MyAround = myAroundAspect.interceptor(example0, example0.getAnnotation(MyAround.class));
    } catch (Exception e) {
      throw new IllegalStateException(e);
    }
  }

  @Override
  public String example(String param0, int param1) {
    var call = new Invocation.Call<>(() -> super.example(param0, param1))
      .with(this, example0, param0, param1);
    try {
      example0MyAround.invoke(call);
      return call.finalResult();
    } catch (InvocationException e) {
      throw e;
    } catch (Throwable e) {
      throw new InvocationException(e);
    }
  }
}
</pre>

<h3 id="fallback">@AOPFallback</h3>
<p>
  We can use <code>@AOPFallback</code> to register a fallback method for an aspect method invocation.
  Recovery methods must return the same type as the target method and may have 4 options for arguments:

 <ul>
   <li>zero arguments
   <li>one <code>Throwable</code> argument
   <li>all the target method's arguments
   <li>the target method's arguments + <code>Throwable</code>.
 </ul>
</p>

<pre content="java">
@Singleton
class ExampleService {

  @MyAround
  public String example(
      String param0, int param1) {
    throw new IllegalStateException();
  }

  @AOPFallback("example")
  public String fallback(
      String param0, int param1, Throwable e) {
    return "fallback-" + param0 + ":" + param1 + ":" + e.getMessage();
  }
}
</pre>

<p>
 Inside our method interceptor, we can use <code>Invocation#invokeRecoveryMethod</code> to recover from an exception.
</p>

<pre content="java">
@Singleton
public class MyAroundAspect implements AspectProvider<MyAround> {

  //rest of aspect provider...

  static class ExampleInterceptor implements MethodInterceptor {
    // MethodInterceptor interception method
    @Override
    public void invoke(Invocation invoke) throws Throwable {
      System.out.println("before args: " + Arrays.toString(invoke.arguments()) + " method: " + invoke.method());
      try {
        invoke.invoke();
      } catch(Exception ex) {
        //recover
        invoke.invokeRecoveryMethod(ex);
      } finally {
        System.out.println("after");
      }
    }
  }
}
</pre>
