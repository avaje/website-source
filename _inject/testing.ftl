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
  <code>@Mock</code>, <code>@Spy</code> and <code>@Captor</code>.
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
  Avaje-Inject provides a JUnit extension similar to this that
</p>

<h3 id="component-testing">Component testing</h3>
<p>
  Component testing is where we look to run tests that use much of the objects with few of
  them mocked out or even nothing mocked out. With component testing we are looking to test
  a scenario / piece of functionality with minimal to no mocking.
</p>
<p>
  With avaje-inject component testing we are getting avaje-inject to "wire" most or all of
  the application with potentially some objects as test doubles (mocks, spies, stubs or dummies).
  For example, we might wire the entire application only using test double for an object that
  makes remote rest calls to another system.
</p>

<h4>JUnit 5 InjectExtension</h4>
<p>
  Avaje-inject provides a JUnit 5 extension <code>InjectExtension</code> that we can use to
  define <code>@Inject</code> as well as mockito <code>@Mock, @Spy, @Captor</code>.
</p>
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

</p>

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
