
<h2 id="jaxrs">JAX-RS</h2><hr/>
<p>
  Why not use the standard JAX-RS annotations?
</p>
<ul>
  <li>The JAX-RS API dependency also has a LOT of other stuff we don't want</li>
  <li>We can improve on JAX-RS making our controllers <b>less verbose</b></li>
</ul>

<p>&nbsp;</p>

<table class="table table-striped">
  <thead>
    <tr>
      <th><h4>avaje http</h4></th>
      <th><h4>JAX-RS</h4></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>@Controller</td>
      <td>-</td>
    </tr>
    <tr>
      <td>@Path</td>
      <td>@Path</td>
    </tr>

    <tr>
      <th colspan="2" class="heading"><h4>HTTP Methods</h4></th>
    </tr>

    <tr>
      <td>@Delete</td>
      <td>@DELETE + @Path</td>
    </tr>
    <tr>
      <td>@Get</td>
      <td>@GET + @Path</td>
    </tr>
    <tr>
      <td>@Post</td>
      <td>@POST + @Path</td>
    </tr>
    <tr>
      <td>@Put</td>
      <td>@PUT + @Path</td>
    </tr>
    <tr>
      <td>@Patch</td>
      <td>@PATCH + @Path</td>
    </tr>

    <tr>
      <th colspan="2" class="heading"><h4>Bean parameters</h4></th>
    </tr>

    <tr>
      <td>@Form</td>
      <td>-</td>
    </tr>

    <tr>
      <td>@BeanParam</td>
      <td>@BeanParam</td>
    </tr>

    <tr>
      <td colspan="2"><h4>Parameters</h4></td>
    </tr>

    <tr>
      <td>Not needed (implied)</td>
      <td>@PathParam</td>
    </tr>
    <tr>
      <td>Not needed (implied)</td>
      <td>@MatrixParam</td>
    </tr>

    <tr>
      <td>@FormParam + @Default</td>
      <td>@FormParam + @DefaultValue</td>
    </tr>
    <tr>
      <td>@QueryParam + @Default</td>
      <td>@QueryParam + @DefaultValue</td>
    </tr>

    <tr>
      <td>@Header</td>
      <td>@HeaderParam</td>
    </tr>

    <tr>
      <td>@Cookie</td>
      <td>@CookieParam</td>
    </tr>

  </tbody>
</table>

