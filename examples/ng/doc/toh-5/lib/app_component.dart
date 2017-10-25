// #docplaster
// #docregion
import 'package:angular/angular.dart';
// #docregion router-import
import 'package:angular_router/angular_router.dart';
// #enddocregion router-import

import 'src/app_routes.dart';
import 'src/hero_service.dart';

@Component(
  selector: 'my-app',
  // #docregion template
  template: '''
    <h1>{{title}}</h1>
    <nav>
      <a routerLink="/dashboard" routerLinkActive="active">Dashboard</a>
      <a routerLink="/heroes" routerLinkActive="active">Heroes</a>
    </nav>
    <router-outlet [routes]="routes.all"></router-outlet>
  ''',
  // #enddocregion template
  // #docregion styleUrls
  styleUrls: const ['app_component.css'],
  // #enddocregion styleUrls
  // #docregion directives
  directives: const [routerDirectives],
  // #enddocregion directives
  providers: const [AppRoutes, HeroService],
)
class AppComponent {
  final title = 'Tour of Heroes';
  final AppRoutes routes;

  AppComponent(this.routes);
}
