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


<h2 id="test-scope">Test scope</h2>
<p>
  Test scope is a special scope used for testing. It effectively provides <em>default dependencies to
    use for all tests</em>.
</p>
<h4>Step 1: Add avaje-inject-test as a test dependency</h4>
<pre content="xml">
  <dependency>
    <groupId>io.avaje</groupId>
    <artifactId>avaje-inject-test</artifactId>
    <version>8.5</version>
    <scope>test</scope>
  </dependency>
</pre>

<h4>Step 2: Add @TestScope</h4>
<p>
  In <code>src/test</code> create a factory bean that we dedicate to creating test scope dependencies.
  Put <code>@TestScope</code> on this factory bean, the beans this factory creates are in our "test scope"
  and will be wired into tests that use avaje-inject
</p>

<h4>Example - AmazonDynamoDB</h4>
<p>
  In the example below, our application has a dependency on <code>AmazonDynamoDB</code>. For testing
  purposes, we want all tests to <em>default</em> to using a test scoped AmazonDynamoDB instance that we set
  up to use a localstack docker container.
</p>
<p>
  Example:
  <a target="_blank" href="https://github.com/avaje/avaje-inject-examples/blob/main/hello-dynamodb/src/test/java/org/foo/myapp/config/MyTestConfiguration.java">
    avaje-inject-examples - hello-dynamodb - MyTestConfiguration.java
  </a>
</p>
<pre content="java">
@TestScope
@Factory
class MyTestConfiguration {

  /**
   * An 'extra' dependency for testing - a docker container running DynamoDB.
   */
  @Bean
  LocalstackContainer dynamoDBContainer() {
    LocalstackContainer container = LocalstackContainer
      .newBuilder("1.13.2")
      .services("dynamodb") // "dynamodb,sns,sqs"
      .build();
    container.start();
    return container;
  }

  /**
   * Default to using this AmazonDynamoDB instance in our tests.
   * This client is setup to use the localstack docker container.
   */
  @Bean
  AmazonDynamoDB dynamoDB(LocalstackContainer container) {
    AmazonDynamoDB dynamoDB = container.dynamoDB();
    createTable(dynamoDB);
    return dynamoDB;
  }
}
</pre>
<p>
  Any component that has AmazonDynamoDB injected into it, will now have the above AmazonDynamoDB instance
  which is set up to talk to the localstack docker container DynamoDB.
</p>

<h4>Step 3: InjectExtension</h4>
<p>
  Generally we create a base test class with <code>@ExtendWith(InjectExtension.class)</code> and
  then have our "component tests" extend that base test class.
</p>
<pre content="java">
  @ExtendWith(InjectExtension.class)
  public abstract class BaseComponentTest {

  }
</pre>
<p>
  The component tests can inject AmazonDynamoDB directly, or typically inject a component that depends
  on AmazonDynamoDB and these will use "our test scoped AmazonDynamoDB instance".
</p>
<pre content="java">
  class DynamoDbComponentTest extends BaseComponentTest {

    /**
     * The test scoped instance.
     */
    @Inject AmazonDynamoDB dynamo;

    /**
     * More typical, a component that depends on AmazonDynamoDB.
     */
    @Inject MyDynamoClient client;

  }
</pre>
<p>
  The "test scoped bean" is by default wired but each test can override this using <code>@Mock</code> or <code>@Spy</code>.
  For that test, the mock or spy is used and wired instead of the "test scoped bean".
</p>
<pre content="java">
  class OtherComponentTest extends BaseComponentTest {

    /**
     * Use this instance for this test.
     */
    @Mock AmazonDynamoDB mockDynamo;

    /**
     * Now wired with mockDynamo for this test.
     */
    @Inject MyDynamoClient client;

  }
</pre>

<h4>Purposes of Test scope beans</h4>
<p>
  Test scope beans generally have one of 3 purposes.
</p>
<h5>1. Extra bean</h5>
<p>
  For testing purposes we want to create an <b>extra</b> bean. For example, the LocalstackContainer that starts a docker container.
</p>

<h5>2. Default bean</h5>
<p>
  We want most of the tests to use a bean (the default one we want to use in tests). For example, we want components to
  use the AmazonDynamoDB instance that will talk to the local docker container.
</p>

<h5>3. Replacement</h5>
<p>
  Say we have a remote API (e.g. Rest call to Github). We don't want any component tests to actually make <em>real calls</em>
  to Github. Instead, we want to have a default stub response and have that as the default. This is similar to (2) but more
  that the default is more like a stub test double.
</p>


<h3 id="component-testing">Component testing</h3>
<p>
  Component testing is where we look to run tests that use most of the objects with their real
  behaviour with less mocked / stubbed behaviour. With component testing we are looking to test a scenario / piece
  of functionality with minimal to no mocking.
</p>
<p>
  The rise and adoption of test docker containers has meant that it is now possible to test significant portions
  of an application without mocking or stubbing resources like databases and messaging.
</p>
<ul>
  <li>Often uses test docker containers for databases, message queues etc</li>
  <li>Use Test scope to provide "default" dependencies (e.g. set up to use the local docker containers)</li>
  <li>Get avaje-inject to "wire" the objects used in the test scenario</li>
  <li>Unlike unit tests, test a scenario with little to no mocking or stubbing</li>
</ul>

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
    <version>8.5</version>
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

<h2 id="programmatic-testing">Programmatic testing</h2>
<p>
  As an alternative to using <em>InjectExtension</em>, we can write component tests programmatically.
  For programmatic style component testing we create a BeanScope and define test doubles that
  we want to use in place of the real things.
</p>

<h3>forTesting()</h3>
<p>
  With the bean scope builder we use <code>forTesting()</code> to give us extra methods for ease of using
  mockito mocks and spies. Use <code>withMock()</code> to specify a dependency to be a Mockito mock.
  Use <code>withSpy()</code> to get a dependency to be a Mockito spy. We can use <code>withBean()</code>
  to supply any sort of test double we like.
</p>

<pre content="java">
@Test
void using_withMock() {

  try (BeanScope scope = BeanScope.newBuilder()
    .forTesting()
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

<pre content="java">
@Test
void using_withSpy() {

  try (BeanScope context = BeanScope.newBuilder()
    .forTesting()
    .withSpy(Pump.class)
    .build()) {

    CoffeeMaker coffeeMaker = context.get(CoffeeMaker.class);
    assertThat(coffeeMaker).isNotNull();
    coffeeMaker.makeIt();

    Pump pump = context.get(Pump.class);
    verify(pump).pumpWater();
  }
}
</pre>
