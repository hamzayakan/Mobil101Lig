/// Uygulama route path sabitleri.
abstract final class RouteNames {
  static const home = '/';
  static const yazboz = '/yazboz';
  static const login = '/login';
  static const leagues = '/leagues';

  static String leagueDetail(String id) => '/leagues/$id';
}
