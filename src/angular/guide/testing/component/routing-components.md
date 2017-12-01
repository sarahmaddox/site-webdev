---
layout: angular
title: "Component Testing: Routing Components"
description: Techniques and practices for component testing of AngularDart apps.
sideNavGroup: advanced
prevpage:
  title: "Component Testing: @Input() and @Output()"
  url: /angular/guide/testing/component/input-and-output
nextpage:
  title: End-to-end Testing
  url: /angular/guide/testing/e2e
---
<?code-excerpt path-base="examples/ng/doc"?>

{% include_relative _page-top-toc.md %}

This page describes how to test routing components using real or mock routers.
Whether or not you mock the router will, among other reasons,  depend on the following:

- The degree to which you wish test your component in isolation
- The effort you are willing to invest in coding mock router behavior for your particular tests

## Running example

This page uses the heroes app from [part 5][] of the [tutorial][] as a running example.
The app component of that revision of the app is just a shell delegating
functionality to either the dashboard or heroes components.

The sample tests for each of these components have been written in a
complementary manner: the heroes component tests use a **mock router**,
whereas those for the dashboard use a **real router**.

## Testing router links using a mock router

In test code excerpt given below, you can see the declaration of a
`MockRouter` class, and a `mockRouter` instance. As described in the section on
[Component-external services: mock or real](services#component-external-services-mock-or-real)
you must add the mock router to the providers list of the `NgTestBed`:

<?code-excerpt "toh-5/test/heroes.dart (excerpt)" region="providers-with-context" title?>
```
  NgTestFixture<HeroesComponent> fixture;
  HeroesPO po;

  final mockRouter = new MockRouter();

  class MockRouter extends Mock implements Router {}

  @AngularEntrypoint()
  void main() {
    final testBed = new NgTestBed<HeroesComponent>().addProviders([
      HeroService,
      provide(Router, useValue: mockRouter),
    ]);

    setUp(() async {
      fixture = await testBed.create();
      po = await fixture.resolvePageObject(HeroesPO);
    });

    tearDown(disposeAnyRunningTest);
    // ···
  }
```

Selecting a hero from the heroes list causes a
["mini detail" view to appear](/angular/tutorial/toh-pt5#add-the-mini-detail):

<img class="image-display" src="{% asset_path 'ng/devguide/toh/mini-hero-detail.png' %}" alt="Mini Hero Detail" width="250">

Clicking the "View Details" button should cause a [request to navigate to the
corresponding hero's detail view](/angular/tutorial/toh-pt5#update-the-heroescomponent-class).
The button's click event is bound to the `gotoDetail()` method which is defined as follows:

<?code-excerpt "toh-5/lib/src/heroes_component.dart (gotoDetail)" title?>
```
  Future<NavigationResult> gotoDetail() =>
      _router.navigate('/detail/${selectedHero.id}');
```

You could test for this behavior by ensuring that the mock router receives
a `Router.navigate()` request with the appropriate [link parameter list][].

In the following test excerpt:

- The `setUp()` method selects a hero.
- The test expects a _single_ call to the mock router's `navigate()` method,
  with the "HeroDetail" route as destination and the target hero's id
  as a parameter.

<a id="heroes-go-to-detail-test"></a>
<code-tabs>
  <?code-pane "toh-5/test/heroes.dart (go-to detail)" linenums?>
  <?code-pane "toh-5/test/heroes_po.dart" linenums?>
</code-tabs>

Tests written using a mock router, embody significant detail concerning the
router's API, and expected argument values such as link parameter lists.

How might you write the same test using a real router? That's covered next.

## Test router links using a real router

The app [dashboard][], from [part 5][] of the [tutorial][], supports direct
navigation to hero details using router links:

<?code-excerpt "toh-5/lib/src/dashboard_component.html (excerpt)" region="click" title?>
```
  <a *ngFor="let hero of heroes" routerLink="/detail/{!{hero.id}!}" class="col-1-4">
    <div class="module hero">
      <h4>{!{hero.name}!}</h4>
    </div>
  </a>
```

One way to test using a real router is to mock the low-level [PlatformLocation][] class.
In addition to providing a mock platform location object,
the real router expects the injector to supply values for:

- The [ROUTER_PROVIDERS][], some of which you'll be overriding
  (like `ROUTER_PRIMARY_COMPONENT`).
- [APP_BASE_HREF][], whose value is usually derived from the
  [`<base href>` element](/angular/tutorial/toh-pt5#base-href)
  in the app's `index.html` file.
- [ROUTER_PRIMARY_COMPONENT][], identifying, as the name implies,
  the component to which the router is bound to.

<?code-excerpt "toh-5/test/dashboard.dart (excerpt)" region="providers-with-context" title?>
```
  NgTestFixture<DashboardComponent> fixture;
  DashboardPO po;

  final mockRouter = new MockRouter();

  class MockRouter extends Mock implements Router {}

  @AngularEntrypoint()
  void main() {
    final testBed = new NgTestBed<DashboardComponent>().addProviders([
      provide(APP_BASE_HREF, useValue: '/'),
      HeroService,
      routerProviders,
      provide(Router, useValue: mockRouter),
    ]);
    // ···
  }
```

The router queries the platform location for location properties such as path and search
parameters. Initialize these appropriately for your app. In the case of the heroes app,
these are initialized to the empty string using
[Mockito.when().thenReturn()][Mockito.when()] calls.

<?code-excerpt "toh-5/test/dashboard.dart (setUpAll)" title?>
```
  // FIXME(docs): we don't need setUpAll() anymore
```

Using this setup, the go-to-detail test illustrated in the previous section, could be written
for the dashboard component as follows:

<?code-excerpt "toh-5/test/dashboard.dart (go to detail)" title?>
```
  test('select hero and navigate to detail', () async {
    clearInteractions(mockRouter);
    await po.selectHero(3);
    var c = verify(mockRouter.navigate(captureAny, captureAny));
    expect(c.captured[0], '/detail/15');
    expect(c.captured[1], new IsNavParams());
    expect(c.captured.length, 2);
  });
```

Contrast this with the [heroes "go to details" test](#heroes-go-to-detail-test)
shown earlier. While the dashboard test requires lower-level configuration of a
mock location, the test has the advantage of ensuring that
[route configurations][] are declared as expected.

{%comment%}
TODO: include code-tabs and show the PO?
{%endcomment%}

## Which routing components can I test?

You can test _any_ routing component, **except the app root** (usually `AppComponent`).
This is because there is a circular dependency between the router
associated with the app root, and the app root instance itself.

In the context of a real app, the
cyclic dependency is resolved by [bootstrapping][], but such
a capability isn't provided by `angular_test`, nor is it generally needed
in the context of component testing.
When the app root is a routing component, it is often only an [app shell][],
delegating most of the work to other components. In such a case, it is these other components
which will be the most useful test subjects.

[APP_BASE_HREF]: /api/angular_router/angular_router/APP_BASE_HREF-constant
[Mockito.when()]: https://www.dartdocs.org/documentation/mockito/2.0.2/mockito/when.html
[PlatformLocation]: /api/angular_router/angular_router/PlatformLocation-class
[ROUTER_PRIMARY_COMPONENT]: /api/angular_router/angular_router/ROUTER_PRIMARY_COMPONENT-constant
[ROUTER_PROVIDERS]: /api/angular_router/angular_router/ROUTER_PROVIDERS-constant
[app shell]: /angular/tutorial/toh-pt5#create-appcomponent
[bootstrapping]: /angular/guide/architecture#dependency-injection
[dashboard]: /angular/tutorial/toh-pt5#add-heroes-to-the-dashboard
[link parameter list]: /angular/guide/router/appendices#link-parameters-list
[part 5]: /angular/tutorial/toh-pt5
[route configurations]: /angular/tutorial/toh-pt5#configure-routes
[tutorial]: /angular/tutorial
