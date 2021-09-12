self: super: {

# Credit to https://github.com/jwiegley/nix-config/blob/c41a8c697c91b459af72b97242575272f98981ab/overlays/30-apps.nix 
installApplication = 
  { name, appname ? name, version, src, description, homepage, 
    postInstall ? "", sourceRoot ? ".", ... }:
  with super; stdenv.mkDerivation {
    name = "${name}-${version}";
    version = "${version}";
    src = src;
    buildInputs = [ undmg unzip ];
    sourceRoot = sourceRoot;
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mkdir -p "$out/Applications/${appname}.app"
      cp -pR * "$out/Applications/${appname}.app"
    '' + postInstall;    
  };

Anki = self.installApplication rec {
  name = "Anki";
  version = "2.1.44";
  sourceRoot = "Anki.app";

  src = super.fetchurl {
    url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-mac.dmg";
    sha256 = "1zrdih4rjsq30480sf200pw59r42p3nq2md56kj2l641kbc7ljka";
  };
  description = "Anki is a program which makes remembering things easy";
  homepage = https://apps.ankiweb.net; 
};

Obsidian = self.installApplication rec {
  name = "Obsidian";
  version = "0.12.10";
  sourceRoot = "Obsidian.app";

  src = super.fetchurl {
    url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/Obsidian-${version}-universal.dmg";
    sha256 = "0yl4zkk9w3r35cgmlsxg1528f678yvwprgfac4hw3x9piyyg8064";
  };
  description = "Obisidan is an application to write notes in Markdown";
  homepage = https://obsidian.md/;
};

Gnucash = self.installApplication rec {
  name = "Gnucash";
  version = "4.6-1";
  sourceRoot = "Gnucash.app";

  src = super.fetchurl {
    url = "https://github.com/kenota/storage/raw/main/Gnucash-Intel-4.6-1.dmg";
    sha256 = "1cl4y3cyqkvbqrgv6za93hpzpp1b4if1ff14ng7ydi66ln8icr0x";
  };

  description = "GnuCash is a double-entry financial application";
  homepage = https://www.gnucash.org/;
};

}
