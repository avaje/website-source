
<h2 id="spring">Spring DI</h2><hr/>

<h4>@Factory + @Bean</h4>
<p>
  <em>avaje-inject</em> has <a href="#factory">@Factory</a> + <a href="#bean">@Bean</a> which work the
  same as Spring DI's <em>@Configuration + @Bean</em> and also Micronaut's <em>@Factory + @Bean</em>.
</p>

<h4>@Primary @Secondary</h4>
<p>
  <em>avaje-inject</em> has <a href="#primary">@Primary</a> and <a href="#secondary">@Secondary</a>
  annotations which work the same as Spring DI's <em>@Primary @Secondary</em> and also Micronaut
  DI's <em>@Primary @Secondary</em>.
</p>
<p>
  These provide injection precedence in the case of injecting an implementation when multiple
  injection candidates are available.
</p>

<p>&nbsp;</p>
<h4 id="spring-translation">Spring DI translation</h4>
<table class="table table-striped">
  <thead class="heading">
  <tr>
    <th width="45%">Spring</th>
    <th width="45%">avaje-inject</th>
    <th width="10%">JSR-330</th>
  </tr>
  <tr>
    <td>@Component, @Service, @Repository</td>
    <td><a href="#singleton">@Singleton</a></td>
    <td>Yes</td>
  </tr>
  <tr>
    <td>FactoryBean&lt;T&gt;</td>
    <td><a href="#provider">Provider&lt;T&gt;</a></td>
    <td>Yes</td>
  </tr>
  <tr>
    <td>@Inject, @Autowired</td>
    <td><a href="#inject">@Inject</a></td>
    <td>Yes</td>
  </tr>
  <tr>
    <td>@Autowired(required=false)</td>
    <td><a href="#optional">@Inject Optional&lt;T&gt;</a></td>
    <td>-</td>
  </tr>
  <tr>
    <td>@PostConstruct</td>
    <td><a href="#post-construct">@PostConstruct</a></td>
    <td>JSR 250</td>
  </tr>
  <tr>
    <td>@PreDestroy</td>
    <td><a href="#pre-destroy">@PreDestroy</a></td>
    <td>JSR 250</td>
  </tr>
  <tr>
    <td colspan="3" align="center" style="padding-top:2em;"><i>Non standard extensions to JSR-330</i></td>
  </tr>
  <tr>
    <td>@Configuration @Bean</td>
    <td><a href="#factory">@Factory @Bean</a></td>
    <td><b>No</b></td>
  </tr>
  <tr>
    <td>@Conditional</td>
    <td><a href="#conditional">@RequiresBean and @RequiresProperty</a></td>
    <td><b>No</b></td>
  </tr>
  <tr>
    <td>@Primary</td>
    <td><a href="#primary">@Primary</a></td>
    <td><b>No</b></td>
  </tr>
  <tr>
    <td>@Profile</td>
    <td><a href="#profile">@Profile</a></td>
    <td><b>No</b></td>
  </tr>
  <tr>
    <td>@Secondary</td>
    <td><a href="#secondary">@Secondary</a></td>
    <td><b>No</b></td>
  </tr>
</table>

<p>&nbsp;</p>
<p>&nbsp;</p>
<h4>Spring DI translation <em>NOT</em> part of avaje-inject</h4>
<table class="table table-striped">
  <thead class="heading">
  <tr>
    <th width="45%">Spring</th>
    <th width="45%">Other</th>
    <th width="10%"></th>
  </tr>
  <tr>
    <td>@Value</td>
    <td><a href="https://avaje.io/config/">avaje-config</a></td>
    <td></td>
  </tr>
  <tr>
    <td>@Controller</td>
    <td><a href="/http/#controller">avaje-http @Controller</a></td>
    <td></td>
  </tr>
  <tr>
    <td>@Transactional</td>
    <td><a href="https://ebean.io/docs/transactions/">Ebean @Transactional</a></td>
    <td></td>
  </tr>
</table>


<h2 id=value>Why we don't have @Value/Refreshable Scopes</h2><hr/>
<p>
  Both Spring and Micronaut have a <code>@Value</code> and by implication, they have chosen to combine "external configuration" in with "dependency injection".
  With avaje-inject a design decision was made to keep these two ideas separate.

  In theory we could have implemented this via source code generation with avaje-inject as:
</p>

<pre content="java">
public class EngineImpl$Proxy extends EngineImpl {

  public EngineImpl$Proxy() { // match super constructor,
    super();
    this.cylinders = Config.getInt("my.engine.cylinders", 6);
  }
}
</pre>

<p>
  Our reasons for not implementing are as follows.
</p>

<h3>Timing of setting the configuration</h3>
<p>
  We can see that <code>cylinders</code> is only set after the <code>super()</code>.
  Any code that tries to use <code>cylinders</code> before that would get a 0 (or null with Integer etc).
  This is relatively obvious to experienced devs but it is a source of bugs for less experienced devs.
  That is, <code>@Value</code> fields have delayed initialization and this can trip people up / be a source of bugs.
 </p>

 <p>
  If we don't use <code>@Value</code> and use <code>Config.getInt()</code> directly on the field, the behavior is completly unambiguous.
  The values are initialized like any normal field.
</p>

<h3>Dynamic Configuration</h3>
<p>
 With avaje-inject we create an effectively immutable BeanScope because we expect "external dynamic configuration" to be done independently from Dependency Injection (for example, by using avaje-config).

 If we go from needing the configuration read and set <i>once at startup</i> to being read each time and potentially changing (aka dynamic configuration).
 Then we'd need to change away from using <code>@Value</code> or add a complex "Refreshable Scope" concept to this llibrary.
</p>

<p>
When using <code>Config.getInt()</code> directly, there is more freedom. We can use it anywhere - field, final field, static final field, in a method (dynamic configuration).
There isn't a big shift between static configuration and dynamic configuration.
</p>

<h3>Freedom</h3>

<p>
  We have an excellent configuration library in <a href="https://avaje.io/config/">avaje-config</a>.
  It's simple, extendable, and mature as it was originally part of Ebean ORM and was extracted into it's own project.
</p>

<p>
  Even so, we want to give our users the freedom to choose whatever they like with external configuration libraries.
  If we supported <code>@Value</code> in avaje-inject then we would have to pick a "configuration implementation" and force our avaje-config dependency where it's potentially unwanted.
</p>
