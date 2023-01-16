
<h2 id="get">@Get</h2>
<p>
  Annotate methods with <code>@Get</code> for HTTP GET web routes.
</p>

<pre content="java">
@Controller("/customers")
class CustomerController {

  @Get
  List<|Customer> getAll() {
    ...
  }

  @Get("/{id}")
  Customer getById(long id) {
    ...
  }

  @Get("/{id}/contacts")
  List<|Contacts> getContacts(long id) {
    ...
  }

}
</pre>


<h2 id="delete">@Delete</h2>
<p>
  Annotate methods with <code>@Delete</code> for HTTP DELETE web routes.
</p>

<h2 id="put">@Put</h2>
<p>
  Annotate methods with <code>@Put</code> for HTTP PUT web routes.
</p>

<h2 id="patch">@Patch</h2>
<p>
  Annotate methods with <code>@Patch</code> for HTTP PUT web routes.
</p>
