<h2 id="conditional">Conditional Beans</h2>

<h3 id="requirebean">@RequiresBean</h3>
<p>
  Put <code>@RequiresBean</code> on a <code>@Factory</code> class, <code>@Factory</code> method,
  or <code>@Singleton</code> class so that a bean will only be registered when the conditions are met.
</p>
<pre content="java">
   @Singleton
   @RequiresBean(Kindling.class)
   @RequiresBean(Cinders.class)
   public class Fire {
      ...
   }
</pre>

<h3 id="requireprops">@RequiresProperty</h3>
<p>
  Put <code>@RequiresProperty</code> on a <code>@Factory</code> class, <code>@Factory</code> method,
  or <code>@Singleton</code> class so that a bean will only be registered when the conditions are met.
</p>
<pre content="java">
   @Singleton
   @RequiresProperty("unkindled")
   @RequiresProperty(value = "fire", notEqualTo = "burning")
   public class Dark {
      ...
   }
</pre>

<p>To test property conditions, an instance of <code>io.avaje.inject.spi.PropertyRequiresPlugin</code> is loaded via <code>java.util.ServiceLoader</code>.

If there are no <code>PropertyRequiresPlugin</code> found, a default implementation will be provided that uses <code>System.getProperty(String)</code> and <code>System.getenv(String)</code>.

<p><a href="https://avaje.io/config/">Avaje Config</a> provides a <code>PropertyRequiresPlugin</code>, so when it's detected in the classpath, it will be used to test the property conditions.

<p>You can provide your own implementation of <code>PropertyRequiresPlugin</code> via service loading if you want to use your own custom testing of property condition.

</p>

<h4>Condition Meta-Annotations</h4>
If multiple beans require the same combination of requirements, you can define a meta-annotation with the requirements:

<pre content="java">
@RequiresBean(Flame.class)
@RequiresBean(value = Kindling.class, missing = Dark.class)
@RequiresProperty(value = "flame.state", notEqualTo = "fading")
public @interface FirstFlame {}
</pre>

These annotation can be placed on beans to easily share conditions.

<pre content="java">
   @Singleton
   @FirstFlame
   @RequiresProperty(value = "flame.state", notEqualTo = "fading")
   public class Light {
      ...
   }
</pre>

Additionally, meta annotation can be placed on other meta annotation to easily compose multiple related conditions.

<pre content="java">
   @FirstFlame
   @RequiresProperty(value = "abyss", equalTo="sealed")
   public @interface AgeOfFire {}
</pre>

<pre content="java">
   @Singleton
   @AgeOfFire
   // AgeOfFire adds the following conditions
   // @RequiresProperty(value = "abyss", equalTo="sealed")
   // @RequiresBean(Flame.class)
   // @RequiresBean(value = Kindling.class, missing = Dark.class)
   // @RequiresProperty(value = "flame.state", notEqualTo = "fading")
   public class Sun {
      ...
   }
</pre>


<h4>Configuration Requirements</h4>

<p>The conditional annotations are pretty flexible and can be used for a variety of use cases. The following table summarizes some common uses:</p>
<table class="table">
  <tr>
    <th >Requirement</th>
    <th >Example</th>
  </tr>
  <tr>
    <td>One or more beans should be present</td>
    <td><code>@RequiresBean({DataSource.class, DBClient.class})</code></td>
  </tr>
  <tr>
    <td>One or more beans should not be present</td>
    <td><code>@RequiresBean(missing = {DataSource.class, DBClient.class})</code></td>
  </tr>
  <tr>
    <td>Beans with the given names/qualifiers should be present</td>
    <td><code>@RequiresBeans(qualifiers = {"blue", "green"})</code></td>
  </tr>
  <tr>
    <td colspan="3" align="center" style="padding-top:2em;"><i>@PropertyRequires</i></td>
  </tr>
  <tr>
    <td>A given property exists</td>
    <td><code>@RequiresProperty("spinning")</code></td>
  </tr>
  <tr>
    <td>Given properties don't exist</td>
    <td><code>@RequiresProperty(missing = {"spiral","nemesis"})</code></td>
  </tr>
  <tr>
    <td>Given property equals a value</td>
    <td><code>@RequiresProperty(value = "drill", equalTo = "spin-on")</code></td>
  </tr>
  <tr>
    <td>Given property does not equal a value</td>
    <td><code>@RequiresProperty(value = "spirit", notEqualTo = "broken")</code></td>
  </tr>
</table>
