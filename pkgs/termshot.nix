{
  stdenv,
  termshot,
  buildGoModule,
  ...
}:
buildGoModule rec {
  pname = "termshot";
  version = "0.2.5";
  src = termshot;
  vendorHash = "sha256-QJ1usezHQHZQZGIVXwP1psO43o6v/qWXeYG9hqAL/yQ=";
}
