// #docplaster
// #docregion
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

// #docregion routes-and-template
import 'src/app_routes.dart';
// #enddocregion routes-and-template
import 'src/hero_service.dart';
// #docregion routes-and-template

@Component(
  // #enddocregion routes-and-template
  selector: 'my-app',
  // #docregion template, routes-and-template
  template: '''
    // #enddocregion routes-and-template
    <h1>{{title}}</h1>
    <a routerLink="/heroes">Heroes</a>
    // #enddocregion template,
    // #docregion routes-and-template
    <!-- ... -->
    // #docregion template,
    <router-outlet [routes]="routes.all"></router-outlet>
  ''',
  // #enddocregion template, routes-and-template
  directives: const [routerDirectives],
  // #docregion routes-and-template
  providers: const [AppRoutes, HeroService],
)
// #docregion routes-and-template
class AppComponent {
  final title = 'Tour of Heroes';
  final AppRoutes routes;

  AppComponent(this.routes);
}
