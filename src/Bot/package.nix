{
  pkgs,
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  stdenv,
  dockerTools,
  ...
}:
let
  fs = lib.fileset;
in
buildDotnetModule (finalAttrs: {
  pname = "BootloaderDeleted";
  version = builtins.readFile ../../version;

  src = fs.toSource {
    root = ./.;

    fileset = fs.difference (./.) (
      fs.unions [
        ./appsettings.Development.json
        (lib.fileset.maybeMissing ./bin)
        (lib.fileset.maybeMissing ./config)
        (lib.fileset.maybeMissing ./obj)

        ./package.nix

        ./.gitignore
      ]
    );
  };

  projectFile = "BootloaderDeleted.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = null;

  executables = [ "BootloaderDeleted" ];

  selfContainedBuild = true;

  nativeBuildInputs = [ stdenv.cc ];

  meta = {
    license = lib.licenses.eupl12;
    mainProgram = "BootloaderDeleted";
    maintainers = with lib.maintainers; [ drakon64 ];
  };

  passthru.docker = dockerTools.buildLayeredImage {
    name = "BootloaderDeleted";
    tag = "latest";

    config.Entrypoint = [ (lib.getExe finalAttrs.finalPackage) ];

    contents = [ dockerTools.caCertificates ];
  };
})
