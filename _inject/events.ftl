<h2 id="events">Events</h2><hr/>

<h3 id="observes">@Observes/@ObservesAsync</h3>
<p>
  Put <code>@Observes/@ObservesAsync</code> on the event parameter of an observer method. An observer method is a non-abstract method of a managed bean class. We can set the priority of the observer using the <em>priority</em> member of the annotation.
</p>

<pre content="java">
@Singleton
class LoginObserver {
 public void afterLogin(@Observes(priority=1) LoggedInEvent event) { ... }
}
</pre>

<p>Each observer method must have exactly one event parameter, of the same type as the event type
it observes. Event qualifiers may be declared by annotating the event parameter with a qualifier such as <code>@Named</code> or any custom qualifier annotations.
When searching for observer methods for an event, the
container considers the type and qualifiers of the event parameter.

<pre content="java">
@Singleton
class LoginObserver {
  public void afterLogin(@Observes @Named("qualified") LoggedInEvent event) { ... }
}
</pre>

<p>If the event parameter does not explicitly declare any qualifier, the observer method observes
events with no qualifier.

<p>The event parameter type may contain a type variable or wildcard.

<h4>Bean Injection </h4>

<p>In addition to the event parameter, observer methods may declare additional parameters, which
may declare qualifiers. These additional parameters are beans that will be injected when an event
has occurred.

<pre content="java">
@Singleton
class LoginObserver {
  public void afterLogin(@Observes LoggedInEvent event, @Manager User user) { ... }
}
</pre>

<h3 id="eventProducers">Event Producers</em></h3>
<p>
  Event producers fire events either synchronously or asynchronously using an instance of the parameterized Event interface.
  An instance of this interface is obtained by injection.
</p>

<pre content="java">
@Singleton
public class CustomEventSender {
  @Inject @Named("qualified") Event<|CustomEvent> customEvent;
}
</pre>

<p>
If not already present, an event publisher is generated which can send events to all registered observers for the given qualifier.
If no qualifier annotations are present, the publisher will default to sending to unqualified observers.
</p>

<pre content="java">
@Component
@Named("qualified")
@Generated("avaje-inject-generator")
public class CustomEvent$Publisher extends Event<|CustomEvent> {

  private static final Type TYPE = CustomEvent.class;

  public CustomEvent$Publisher(ObserverManager manager) {
    super(manager, TYPE, "qualified");
  }
}
</pre>

<h3 id="sending">Sending Events</em></h3>
<p>
  A producer raises events by calling the <code>fire()</code> or <code>fireAsync()</code> methods of the Event interface, passing the event object:
</p>

<pre content="java">
@Component
public class EventService {

  Event<|CustomEvent> eventPublisher;

  public EventService(Event<|CustomEvent> eventPublisher) {
    this.eventPublisher = eventPublisher;
  }

  void process(){
    CustomEvent event = //...
    eventPublisher.fire(event);
    eventPublisher.fireAsync(event);
  }
}
</pre>

<p>This particular event will only be delivered to (a)synchronous observer methods that:
<ul>
  <li>Have an event parameter of <code>CustomEvent</code></li>
  <li>Specifies no qualifiers.</li>
</ul>
<p>
  <code>fire()</code> simply calls all the synchronous observer methods, passing the event object as the value of the event parameter. If any observer method throws an exception, the container stops calling observer methods, and the exception is rethrown by the fire() method.
</p>
<p>
  <code>fireAsync()</code> returns immediately and all the resolved asynchronous observers are notified in
 one or more different threads.
 If any observer method throws an exception, the container will suppress it and notify remaining observers.
 The resulting CompletionStage will then finish exceptionally with <code>CompletionException</code> containing all previously suppressed exceptions.
</p>

<h4 id="eventQualifiers">Applying qualifiers to events</h4>
<p>
  Qualifiers can be applied to an event in one of two ways:
  <ul>
    <li>By annotating the <code>Event</code> injection point</li>
    <li>By passing the stringified qualifier to the fire/fireAsync methods of Event.</li>
  </ul>
</p>
<p>
  Specifying the qualifiers at the injection point is by far the simpler option:
</p>
<pre content="java">
@Component
public class EventService {

  Event<|CustomEvent> eventPublisher;

  public EventService(@Red Event<|CustomEvent> eventPublisher) {
    this.eventPublisher = eventPublisher;
  }
}
</pre>

<p>
  Unless overridden by a manually specified qualifier, the above injected <code>Event</code>'s fire/fireAsync methods will by defaul send with the <em>Red</em> qualifier. The event is delivered to every observer method that:
<ul>
  <li>Have an event parameter of <code>CustomEvent</code></li>
  <li>Specifies the @Red qualifier.</li>
</ul>
The downside of annotating the injection point is that we can't specify the qualifier dynamically.
</p>

<p>
  The below example shows how to send events with a dynamic qualifier
</p>
<pre content="java">
@Component
public class EventService {

  Event<|CustomEvent> eventPublisher;

  public EventService(@Red Event<|CustomEvent> eventPublisher) {
    this.eventPublisher = eventPublisher;
  }
  void process(){
    CustomEvent event = //...
    eventPublisher.fire(event, "Green"); //overrides the default Red qualifier
    eventPublisher.fireAsync(event, "Blue");
  }
}
</pre>
