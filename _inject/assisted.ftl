<h2 id="assistInject">Assisted Injection</h3><hr/>
Assisted injection is a dependency injection pattern used to construct an object where some parameters may be provided by the DI framework and others must be passed in at creation time (“assisted” if you will) by the user.

<br><br>Avaje Inject will generate a factory implementation responsible for combining all of the parameters and creating the object.

<h3 id="assistFactory">@AssistFactory</h3>
<p>
    To use assisted injection, annotate a class with <code>@AssistFactory</code> to signal the generator to create a factory class.
    <code>@AssistFactory</code> requires an interface/abstract class type that has the assisted types as parameters.
</p>
<p>
    To mark fields/method parameters as assisted, annotate them with @Assisted, as shown below:
</p>

<pre content="java">
@AssistFactory(CarFactory.class)
public class Car {

  @Assisted Make make;
  @Inject Wheel wheel;

  public Car(@Assisted Paint paint, @Nullable Engine engine) {
  //  ...
  }

  //will be triggered after contruction
  @Inject
  void injectMethod(@Assisted int size, Steel steel) {
  //  ...
  }

  //Factory Type the generated code will implement
  public interface CarFactory {
    Car fabricate(Paint paint, int size, Make make);
  }
}
</pre>

<p>We can now wire a factory instance and use in our application</p>

<pre content="java">
@Singleton
public class Dealer {

  CarFactory factory;

  @Inject
  public Dealer(CarFactory factory) {
    this.factory = factory;
  }


  Car orderCar(Order order) {
    //  ...
    return factory.fabricate(paint, size, make)
  }
}
</pre>

<h4>Generated Code</h4>
<p>
  Avaje Inject will read an assisted bean to generate a factory, here is the generated factory for the above <code>Car</code> class:
</p>
<pre content="java">
@Component
final class Car$AssistFactory implements CarFactory {

  @Inject
  Wheel wheel$field;

  private Steel steel$method;
  private final Engine engine;

  Car$AssistFactory(@Nullable Engine engine) {
    this.engine = engine;
  }

  /**
   * Fabricates a new Car.
   */
  @Override
  public Car construct(Paint paint, int size, Make make) {
    var bean = new Car(paint, engine);
    bean.wheel = wheel$field;
    bean.make = make;
    bean.injectMethod(size, steel$method);
    return bean;
  }

  @Inject
  void injectMethod(Steel steel) {
    this.steel$method = steel;
  }
}
</pre>
