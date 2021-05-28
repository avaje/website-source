<h2 id="testing">Testing</h2>

<h3 id="unit-testing">Unit testing</h3>
<p>
  When we are <em>unit testing</em> we are not using avaje-inject. We are focused on the
  thing we want to test (object under test) and it's dependencies.
</p>
<p>
  With unit testing in the test setup code will create the thing we are testing (object under test)
  along with it's dependencies.
</p>

<h5>Mockito programmatic style</h5>
<pre content="java">
  // setup
  final Pump pump = mock(Pump.class);
  final Grinder grinder = mock(Grinder.class);
  CoffeeMaker coffeeMaker = new CoffeeMaker(pump, grinder);

  // act
  coffeeMaker.makeIt();

  verify(pump).pumpSteam();
  verify(grinder).grindBeans();
</pre>

<h5>Mockito junit5 extension</h5>
<p>
  Mockito provides a JUnit 5 extension <code>MockitoExtension</code> which can be used
  with JUnit <code>@ExtendWith</code>. With this extension we can annotate fields with
  <code>@Mock</code>, <code>@Spy</code> and <code>@Captor</code>. Again, this is all
  Mockito - no avaje inject is used here.
</p>
<pre content="java">
  @ExtendWith(MockitoExtension.class)
  class CoffeeMakerTest {

    @Mock Pump pump;
    @Mock Grinder grinder;

    @Test
    void extensionStyle() {

      // setup
      CoffeeMaker coffeeMaker = new CoffeeMaker(pump, grinder);

      // act
      coffeeMaker.makeIt();

      verify(pump).pumpSteam();
      verify(grinder).grindBeans();
    }
  }
</pre>
<p>
  avaje-inject is NOT used in the above unit tests (as expected). We will see below that avaje-inject
  provides a JUnit extension similar to the Mockito one and that uses the Mockito annotations
  <code>@Mock, @Spy, @Captor</code> and also adds <code>@Inject</code>.
</p>

<h3 id="component-testing">Component testing</h3>
<p>
  Component testing is where we look to run tests that use most of the objects with their real
  behaviour and only a few of the objects with mocked / stubbed behaviour. With component testing
  we are looking to test a scenario / piece of functionality with minimal to no mocking.
</p>
<p>
  With avaje-inject component testing we are getting avaje-inject to "wire" most or all of
  the application with potentially some objects as test doubles (mocks, spies, stubs or dummies).
  For example, we might wire the entire application only using test doubles for objects that
  make remote calls to another system.
</p>

<h4>JUnit 5 InjectExtension</h4>
<p>
  avaje-inject provides a JUnit 5 extension <code>InjectExtension</code>. With this we use
  <code>@Inject</code> as well as mockito's <code>@Mock, @Spy, @Captor</code> to define the
  objects we wish to use in the test.
</p>
<p>
  Add <em>avaje-inject-test</em> as a test dependency.
</p>
<pre content="xml">
  <dependency>
    <groupId>io.avaje</groupId>
    <artifactId>avaje-inject-test</artifactId>
    <version>6.0.RC3</version>
    <scope>test</scope>
  </dependency>
</pre>

<pre content="java">
  @ExtendWith(InjectExtension.class)
  class CoffeeMakerTest {

    @Mock Pump pump;
    @Mock Grinder grinder;
    @Inject CoffeeMaker coffeeMaker;

    @Test
    void extensionStyle() {

      // act
      coffeeMaker.makeIt();

      verify(pump).pumpSteam();
      verify(grinder).grindBeans();
    }
  }
</pre>
<p>
  With <em>InjectExtension</em> avaje-inject will build a BeanScope will the appropriate mockito
  mocks and spies and inject back into the test the appropriate objects out of the BeanScope.
</p>
<h4>@Named and @Qualifier</h4>
<p>
  We can use <code>@Named</code> and qualifiers as needed like below.
</p>
<pre content="java">

    @Mock @Blue Store blueStore;

    @Mock @Named("red") Store redStore;

</pre>

<h4>Programmatic style component test</h4>
<p>
  For programmatic style component testing we create a BeanScope and define test doubles that
  we want to use in place of the real things. We can use <code>withMock()</code> to get a
  dependency to be a Mockito mock. We can use <code>withSpy()</code> to get a dependency to
  be a Mockito spy. We can use <code>withBean()</code> to supply any sort of test double we
  like.
</p>

<pre content="java">
@Test
void myComponentTest() {

  try (BeanScope scope = BeanScope.newBuilder()
    .withMock(Pump.class)
    .withMock(Grinder.class)
    .build()) {

    // act
    CoffeeMaker coffeeMaker = scope.get(CoffeeMaker.class);
    coffeeMaker.makeIt();

    verify(pump).pumpSteam();
    verify(grinder).grindBeans();
}
</pre>
