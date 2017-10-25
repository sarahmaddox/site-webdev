// #docplaster
// #docregion , v2
// #docregion added-imports
import 'dart:async';

// #enddocregion added-imports
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
// #docregion added-imports
import 'package:angular_router/angular_router.dart';

// #enddocregion added-imports
import 'hero.dart';
// #docregion added-imports
import 'hero_service.dart';
// #enddocregion added-imports

// #docregion metadata, metadata-wo-style
@Component(
  selector: 'hero-detail',
  // #docregion templateUrl
  templateUrl: 'hero_detail_component.html',
  // #enddocregion metadata-wo-style, templateUrl, v2
  styleUrls: const ['hero_detail_component.css'],
  // #docregion metadata-wo-style
  directives: const [CORE_DIRECTIVES, formDirectives],
  // #docregion v2
)
// #enddocregion metadata, metadata-wo-style
// #docregion OnActivate, hero
class HeroDetailComponent implements OnActivate {
  // #enddocregion OnActivate
  Hero hero;
  // #enddocregion hero
  // #docregion ctor
  final HeroService _heroService;
  final Location _location;

  HeroDetailComponent(this._heroService, this._location);
  // #enddocregion ctor

  // #docregion OnActivate
  @override
  void onActivate(_, RouterState current) {
    updateHero(current);
  }
  // #enddocregion OnActivate

  // #docregion updateHero
  Future<Null> updateHero(RouterState routerState) async {
    var _id = routerState.parameters['id'];
    var id = int.parse(_id ?? '', onError: (_) => null);
    if (id != null) hero = await (_heroService.getHero(id));
  }
  // #enddocregion updateHero

  // #docregion goBack
  void goBack() => _location.back();
  // #enddocregion goBack
  // #docregion hero, OnActivate
}
