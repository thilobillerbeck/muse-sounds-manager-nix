{
  description = "Muse Sounds Manager (unofficial)";
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      version = "1.1.0.587";
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          muse-sounds-manager-bin = pkgs.stdenv.mkDerivation {
            name = "muse-sounds-manager-bin";
            nativeBuildInputs = with pkgs; [ rpmextract ];

            src = pkgs.fetchurl {
              url = "https://web.archive.org/web/20240213215205/https://muse-cdn.com/Muse_Sounds_Manager_Beta.rpm";
              sha256 = "sha256-GQLJt3j8LLRTQ4E59vz75IAp9ePetap7RFvat0umifs=";
            };

            unpackPhase = ''
              rpmextract $src
            '';

            installPhase = ''
              mkdir -p $out/bin
              mkdir -p $out/share
              cp -r opt/muse-sounds-manager/* $out
              cp -r usr/share/* $out/share
            '';
          };
        in
        {
          muse-sounds-manager = pkgs.buildFHSEnv {
            pname = "muse-sounds-manager";
            version = version;

            targetPkgs = pkgs: with pkgs; [
              xorg.libX11
              xorg.libSM
              xorg.libICE
              fontconfig
              zlib
              openssl
              libz
              icu
            ];

            extraInstallCommands = ''
              mkdir -p $out/share
              cp -r ${muse-sounds-manager-bin}/share/* $out/share
            '';

            runScript = "${muse-sounds-manager-bin}/Muse.Client.Linux";

            meta = with pkgs.lib; {
              description = "A download manager for Muse Sounds.";
              homepage = "https://www.musehub.com";
              license = licenses.unfree;
              platforms = platforms.linux;
            };
          };
        });

      defaultPackage = forAllSystems (system: self.packages.${system}.muse-sounds-manager);
    };
}
