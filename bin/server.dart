import 'dart:io';
import 'package:dart_redstone_starterkit/hero_service.dart';
import 'package:dart_redstone_starterkit/in_memory_data_service.dart';
import 'package:di/di.dart';
import 'package:http/http.dart';
import 'package:redstone/redstone.dart' as web;


@web.Route("/")
helloWorld() => "Hello, World!";

@web.Route("/users/:id")
getUser(String id) => {"userId": id, "name": "User", "login": "user"};

@web.Group("/heroes")
class HeroController {
  HeroService _service;
  HeroController(this._service);

  @web.Route("/list")
  service() => _service.getHeroes().then((heroes) => {"heroes": heroes});

}

@web.Interceptor(r'/admin/.*')
adminFilter() {
  if (web.request.session["username"] != null) {
    web.chain.next();
  } else {
    web.chain.abort(HttpStatus.UNAUTHORIZED);
  }
}


void main() {
  web.addModule(new Module()
    ..bind(Client, toImplementation: InMemoryDataService)
    ..bind(HeroService)
  );
  web.setupConsoleLog();
  web.start();
}
