<h2 id="roles">Roles</h2>
<p>
  We can optionally add declarative security role checking for Javalin and Jex.
</p>

<h5>Example</h5>
<pre content="java">
@Controller
@Path("/customers")
class CustomerController  {

  @Roles({AppRoles.ADMIN, AppRoles.BASIC_USER})
  @Get("/{id}")
  Customer find(int id) {
    ...
  }
</pre>

<h2 id="roles-javalin">Javalin Roles</h2>
<p>
  Example reference <a href="https://github.com/avaje/avaje-http/blob/master/tests/test-javalin/src/main/java/org/example/myapp/web/HelloController.java#L58">test-javalin - HelloController</a>
</p>
<h4>Step 1: Create an enum that implements io.avaje.jex.Role</h4>
<p>
  Create an enum that implements <code>io.avaje.jex.Role</code>.
</p>
<pre content="java">
import io.javalin.core.security.Role;

public enum AppRoles implements Role {
  ANYONE, ADMIN, BASIC_USER, ORG_ADMIN
}
</pre>

<h4>Step 2: Create a Roles / PermittedRoles annotation</h4>
<p>
  Create an annotation that has a short name that ends with Roles or PermittedRoles.
  The annotation must follow this naming convention to be detected by the annotation
  processor (code generation).
</p>
<p>
  The annotation must have a <code>value()</code> attribute that specifies the
  enum role type specified in Step 1.
</p>

<h5>Example</h5>
<pre content="java">
package org.example.myapp.web;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.ElementType.TYPE;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

/**
 * Specify permitted roles.
 */
@Target(value={METHOD, TYPE})
@Retention(value=RUNTIME)
public @interface Roles {

  /**
   * Specify the permitted roles.
   */
  AppRoles[] value() default {};
}
</pre>

<h4>Step 3: Use the annotation</h4>
<p>
  Add the annotation to any controller or controller methods as desired.
</p>

<h5>Example</h5>
<pre content="java">

  @Roles({AppRoles.ADMIN, AppRoles.BASIC_USER})
  @Get("/{id}")
  Customer find(int id) { ...
</pre>

<h4>Step 4: Javalin AccessManager</h4>
<p>
  Ensure that Javalin is setup with an AccessManager to implement the role check.
</p>
<pre content="java">
Javalin app = Javalin.create(config -> {
  ...
  config.accessManager((handler, ctx, permittedRoles) -> {
    // implement role permission check
    ...
  });
});
</pre>




<h2 id="roles-jex">Jex Roles</h2>
<p>
  Example reference <a href="https://github.com/avaje/avaje-http/blob/master/tests/test-jex/src/main/java/org/example/web/HelloController.java#L28">test-jex - HelloController</a>
</p>
<p>

</p>
<h4>Step 1: Create an enum that implements io.avaje.jex.Role</h4>
<p>
  Create an enum that implements <code>io.avaje.jex.Role</code>.
</p>
<pre content="java">
import io.avaje.jex.Role

public enum AppRoles implements Role {
  ANYONE, ADMIN, BASIC_USER, ORG_ADMIN
}
</pre>

<h4>Step 2: Create a Roles / PermittedRoles annotation</h4>
<p>
  Create an annotation that has a short name that ends with Roles or PermittedRoles.
  The annotation must follow this naming convention to be detected by the annotation
  processor (code generation).
</p>
<p>
  The annotation must have a <code>value()</code> attribute that specifies the
  enum role type specified in Step 1.
</p>

<h5>Example</h5>
<pre content="java">
package org.example.myapp.web;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.ElementType.TYPE;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

/**
 * Specify permitted roles.
 */
@Target(value={METHOD, TYPE})
@Retention(value=RUNTIME)
public @interface Roles {

  /**
   * Specify the permitted roles.
   */
  AppRoles[] value() default {};
}
</pre>

<h4>Step 3: Use the annotation</h4>
<p>
  Add the annotation to controller methods or the controller as desired.
</p>

<h5>Example</h5>
<pre content="java">
  @Roles({AppRoles.ADMIN, AppRoles.BASIC_USER})
  @Get("/{id}")
  Customer find(int id) { ...
</pre>

<h4>Step 4: Jex AccessManager</h4>
<p>
  Ensure that Jex is setup with an AccessManager to implement the role check.
</p>

<h5>Example</h5>
<pre content="java">
jex.accessManager((handler, ctx, permittedRoles) -> {
  ...
})
</pre>
