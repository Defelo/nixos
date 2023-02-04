{
  rustPlatform,
  fetchCrate,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "sea-orm-cli";
  version = "0.10.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-QLhTIKep/h/2w9GczbAzirfj6FKP3XFO54wMqvRAlks=";
  };

  cargoSha256 = "sha256-GEeGANhIPu3uOCZPjSOrSOB1wQGHuj69OvHloJZpq8o=";

  buildNoDefaultFeatures = true;
  buildFeatures = ["codegen" "cli" "runtime-async-std-rustls" "async-std"];
}
