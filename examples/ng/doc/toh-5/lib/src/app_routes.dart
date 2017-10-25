// #docplaster
// #docregion , a-first-route, hct
// ignore_for_file: uri_has_not_been_generated
// #enddocregion hct
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

// #enddocregion a-first-route
// #docregion dct
import 'dashboard_component.template.dart' as dct;
// #enddocregion dct
// #docregion hdct
import 'hero_detail_component.template.dart' as hdct;
// #enddocregion hdct
// #docregion a-first-route, hct
import 'heroes_component.template.dart' as hct;
// #enddocregion a-first-route, hct
// #docregion a-first-route

@Injectable()
class AppRoutes {
  final List<RouteDefinition> all = [
    // #enddocregion a-first-route
    // #docregion redirect-route
    new RouteDefinition.redirect(path: '', redirectTo: 'dashboard'),
    // #enddocregion redirect-route
    // #docregion dashboard-route
    new RouteDefinition(
      path: 'dashboard',
      component: dct.DashboardComponentNgFactory,
      useAsDefault: true,
    ),
    // #enddocregion dashboard-route
    // #docregion a-first-route
    new RouteDefinition(
      path: 'heroes',
      component: hct.HeroesComponentNgFactory,
    ),
    // #enddocregion a-first-route
    // #docregion hero-detail-route
    new RouteDefinition(
      path: 'detail/:id',
      component: hdct.HeroDetailComponentNgFactory,
    ),
    // #enddocregion hero-detail-route
    // #docregion a-first-route
  ];
}
