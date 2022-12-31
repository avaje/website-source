<h2 id="testing">Testing</h2>

<h3 id="unit-testing">Unit Testing</h3>
<p>
  When we are <em>unit testing</em> we are focused on the
  thing we want to test (object under test) and it's dependencies.
</p>
<p>
  In the test setup, code will create the thing we are testing (object under test)
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




<h2 id="component-testing">Component testing</h2>
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

<h3 id="test-dependency">dependency</h3>
<p>
  Add <em>avaje-inject-test</em> as a test dependency.
</p>
<pre content="xml">
  <dependency>
    <groupId>io.avaje</groupId>
    <artifactId>avaje-inject-test</artifactId>
    <version>${avaje.inject.version}</version>
    <scope>test</scope>
  </dependency>
</pre>


<h3 id="inject-test">@InjectTest</h3>
<p>
  avaje-inject provides a JUnit 5 extension via <code>@InjectTest</code>.
  When a test is annotated with <code>@InjectTest</code> then avaje-inject will be used to setup the
  test using <code>@Inject</code> as well as mockito's <code>@Mock, @Spy, @Captor</code>.
</p>
<p>
  With <em>@InjectTest</em> avaje-inject will build a BeanScope will the appropriate mockito
  mocks and spies and inject back into the test the appropriate objects out of the BeanScope.
</p>
<pre content="java">
  @InjectTest
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
  The above test using <code>@InjectTest</code> is equivalent to the test below
  that programmatically creates a BeanScope and performs the same test.
</p>
<pre content="java">
@Test
void programmaticStyle() {

  try (var beanScope = TestBeanScope.builder()
    .forTesting()
    .mock(Pump.class)
    .mock(Grinder.class)
    .build()) {

    CoffeeMaker coffeeMaker = beanScope.get(CoffeeMaker.class);

    // act
    coffeeMaker.makeIt();

    verify(beanScope.get(Pump.class)).pumpSteam();
    verify(beanScope.get(Grinder.class)).grindBeans();
}
</pre>
<p>
  If we look closely at the test above, we will see the use of <code>TestBeanScope.builder()</code>
  rather than the usual <code>BeanScope.builder()</code>. We use TestBeanScope to automatically use
  the <a href="#test-scope">"test scope"</a> if it exists.
</p>

<h3>@Named and @Qualifier</h3>
<p>
  We can use <code>@Named</code> and qualifiers as needed with <em>@Mock, @Spy, and @Inject</em> like below.
</p>
<pre content="java">

    @Mock @Blue Store blueStore;

    @Mock @Named("red") Store redStore;

</pre>

<h3>Static fields, Instance fields</h3>
<p>
  With <code>@InjectTest</code> we can inject into static fields and non-static fields.
  Under the hood, these map to BeanScopes that are created and used to populate these fields in the tests.
</p>
<h4>static fields - Junit All</h4>
<p>
  With static fields there is an underlying BeanScope that is created and used for all
  tests in the test class. In the example below, the static Foo is in that BeanScope.
</p>
<p>
  This matches Junit5 <em>All</em> - <code>@BeforeAll, @AfterAll</code> etc.
</p>
<p>
  This BeanScope is created and used for all tests that run for that test class. This scope will be
  closed after all tests for the class have been run.
  The "global test scope" (if defined) will be the parent bean scope.
</p>

<h4>non-static fields - Junit Each</h4>
<p>
  For non-static fields, there is a BeanScope that is created for these. In the example
  below Bar and Bazz are in that BeanScope. With the 3 test methods <code>one(), two(), three()</code>
  this BeanScope is created (and closed) for each test so 3 times.
</p>
<p>
  This matches Junit5 <em>Each</em> - <code>@BeforeEach, @AfterEach</code> etc.
</p>
<p>
  This BeanScope is created for each test and closed after that test has been run.
  It can have a parent bean scope of either the "test static scope" if defined for that test, or
  the "global test scope" (if defined).
</p>
<pre content="java">
  @InjectTest
  class MyTest {

    static @Mock Foo foo;
    @Mock Bar bar;
    @Inject Bazz bazz;

    @Test
    void one() {
      ...
    }

    @Test
    void two() {
      ...
    }

    @Test
    void three() {
      ...
    }

  }
</pre>
<p>
  The above <code>MyTest</code> runs 3 tests, <code>one(), two(),</code> and <code>three()</code>.

</p>
<p>
  <em>Static Foo field</em> is wired once and the same foo instance would be used for ALL three tests.
</p>
<p>
  <em>Instance Bar, Bazz fields</em> are wired for each of the three tests - they are wired 3 times.
</p>
<p>
  This can be represented by the diagram below. <em>Bar, Bazz</em> are created and injected 3 times.
  <em>Static Foo</em> is created and injected once.
</p>
<p>
  <img src="/images/inject/inject-static-instance.png" width="100%">
</p>
<p>
  &nbsp;
</p>
<p>
  The above test can be programmatically written as below. In the code below, we see:
</p>
<ul>
  <li><em>staticScope</em> that spans all the tests. Created in <code>beforeAll()</code> and closed in <code>afterAll()</code>.</li>
  <li><em>instanceScope</em> that is created in <code>beforeEach()</code> and closed in <code>afterEach()</code></li>
</ul>

<pre content="java">
  class MyTest {

    // static fields
    static @Mock Foo foo;

    // instance fields
    @Mock Bar bar;
    @Inject Bazz bazz;

    static BeanScope staticScope; // "static forAll" scope
    BeanScope instanceScope    // "instance forEach" scope

    @BeforeAll
    static void beforeAll() {
      staticScope = TestBeanScope.builder()
          .forTesting()
          .mock(Foo.class)
          .build()
      foo = staticScope.get(Foo.class);
    }

    @AfterAll
    static void afterAll() {
      staticScope.close()
    }

    @BeforeEach
    void beforeEach() {
      instanceScope = TestBeanScope.builder().parent(staticScope)
          .forTesting()
          .mock(Bar.class)
          .build()
      bar = instanceScope.get(Bar.class);
      bazz = instanceScope.get(Bazz.class);
    }

    @AfterEach
    void afterEach() {
      instanceScope.close()
    }


    @Test
    void one() {
      ...
    }

    @Test
    void two() {
      ...
    }

    @Test
    void three() {
      ...
    }
  }
</pre>

<h3 id="test-scope-parent">Parent child hierarchy</h3>
<p>
  When using <code>@InjectTest</code> we get a 3 level parent child hierarchy of <em>BeanScope</em>.
</p>
<ol>
  <li>Global <a href="#test-scope">test scope</a> that spans ALL tests. This is detailed in the next section.</li>
  <li>Static/All BeanScope - when there are static fields to <em>@Inject, @Mock or @Spy</em>.</li>
  <li>Instance/Each BeanScope - when there are instance fields to <em>@Inject, @Mock or @Spy</em>.</li>
</ol>

<h3>All 3 scopes</h3>
<p>
  When we have all 3 scopes they form a parent child hierarchy as per the diagram below. The "global test scope"
  is the parent of the "static/all scope".  The "static/all scope" is the parent of each "instance/each scope".
</p>
<p>
  <img src="/images/inject/inject-parent.png" width="100%">
</p>

<p>&nbsp;</p>
<h3>Only instance fields</h3>
<p>
  When a test only has instance fields with <em>@Inject, @Mock or @Spy</em> then the global test scope (if defined)
  is the parent of the instance/each scopes.
</p>
<p>
  In this case, <code>@InjectTest</code> detects that there are no static fields to wire and will not create a BeanScope for the
  static/all scope.
</p>
<p>
  <img src="/images/inject/inject-parent-onlyinstance.png" width="100%">
</p>

<p>&nbsp;</p>
<h3>Only static fields</h3>
<p>
  When a test only has static fields with <em>@Inject, @Mock or @Spy</em> then the global test scope (if defined)
  is the parent of the static/all scope. This static/all scope is used by all the tests that run.
</p>
<p>
  In this case, <code>@InjectTest</code> detects that there are no instance fields to wire and will not create a BeanScope for
  each instance/each scope.
</p>
<p>
  <img src="/images/inject/inject-parent-onlystatic.png" width="100%">
</p>

<p>&nbsp;</p>
<h2 id="test-scope">@TestScope - global test scope</h2>
<p>
  When we use <code>@TestScope</code> we create a special bean scope used for testing that spans <em>ALL TESTS</em>.
  It effectively provides <em>default dependencies to use for ALL tests</em>. As such we can think of it as the
  "global test scope".
</p>
<p>
  Under the hood, the global test BeanScope is created when junit starts, this test BeanScope holds all the beans
  that we put in <code>@TestScope</code> and this scope is used as the parent BeanScope for <code>@InjectTest</code>
  tests.
</p>
<p>
  <img src="/images/inject/inject-global-test-scope.png" width="100%">
</p>

<h4>Step 1: Add @TestScope</h4>
<p>
  In <code>src/test</code> create a factory bean that we dedicate to creating test scope dependencies.
  Put <code>@TestScope</code> on this factory bean, the beans this factory creates are in our "test scope"
  and will be wired into tests that use <code>@InjectTest</code>.
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
/**
 * All beans wired by this factory will be in the "global test scope".
 */
@TestScope
@Factory
class MyTestConfiguration {

  /**
   * An 'extra' dependency for testing - a docker container running DynamoDB.
   */
  @Bean
  LocalstackContainer dynamoDBContainer() {
    LocalstackContainer container = LocalstackContainer
      .builder("0.14.2")
      .services("dynamodb") // e.g. "dynamodb,sns,sqs"
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

<h4>Step 2: @InjectTest</h4>
<p>
  Annotation the test class with <code>@InjectTest</code>.
</p>
<p>
  The component tests can inject AmazonDynamoDB directly, or typically inject a component that depends
  on AmazonDynamoDB and these will use "our test scoped AmazonDynamoDB instance".
</p>
<pre content="java">
  @InjectTest
  class DynamoDbComponentTest {

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
  @InjectTest
  class OtherComponentTest {

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

<p>
  Note that <code>@InjectTest</code> is syntactic sugar for junit5 <code>@ExtendWith(InjectExtension.class)</code>
</p>



<h2 id="programmatic-testing">Programmatic testing</h2>
<p>
  As an alternative to using <em>InjectExtension</em>, we can write component tests programmatically.
  For programmatic style component testing we create a BeanScope and define test doubles that
  we want to use in place of the real things.
</p>

<h3>TestBeanScope.builder()</h3>
<p>
  For tests we should always use <code>TestBeanScope.builder()</code> rather than <code>BeanScope.builder()</code>.
</p>
<p>
  By using <code>TestBeanScope.builder()</code> it will use the global test scope as a parent bean scope - we
  generally always want to do that for tests.
</p>
<p>
  If we never use the global test scope then we can use <code>BeanScope.builder()</code>.
</p>


<h3>forTesting()</h3>
<p>
  With the bean scope builder we use <code>forTesting()</code> to give us extra methods for ease of using
  mockito mocks and spies. Use <code>mock()</code> to specify a dependency to be a Mockito mock.
  Use <code>spy()</code> to get a dependency to be a Mockito spy. We can use <code>bean()</code>
  to supply any sort of test double we like.
</p>

<pre content="java">
@Test
void using_mock() {

  try (BeanScope scope = TestBeanScope.builder()
    .forTesting()
    .mock(Pump.class)
    .mock(Grinder.class)
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
void using_spy() {

  try (BeanScope context = TestBeanScope.builder()
    .forTesting()
    .spy(Pump.class)
    .build()) {

    CoffeeMaker coffeeMaker = context.get(CoffeeMaker.class);
    assertThat(coffeeMaker).isNotNull();
    coffeeMaker.makeIt();

    Pump pump = context.get(Pump.class);
    verify(pump).pumpWater();
  }
}
</pre>
