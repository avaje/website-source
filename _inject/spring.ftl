
<h2 id="spring">Spring DI</h2>

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
<table class="table">
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
    <td>@Primary</td>
    <td><a href="#primary">@Primary</a></td>
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
<table class="table">
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

