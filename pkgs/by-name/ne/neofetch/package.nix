{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bash,
  makeWrapper,
  pciutils,
  x11Support ? !stdenvNoCC.isOpenBSD,
  ueberzug,
  fetchpatch,
}:

stdenvNoCC.mkDerivation rec {
  pname = "neofetch";
  version = "unstable-2021-12-10";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = "ccd5d9f52609bbdcd5d8fa78c4fdb0f12954125f";
    sha256 = "sha256-9MoX6ykqvd2iB0VrZCfhSyhtztMpBTukeKejfAWYW1w=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/dylanaraps/neofetch/commit/413c32e55dc16f0360f8e84af2b59fe45505f81b.patch";
      sha256 = "1fapdg9z79f0j3vw7fgi72b54aw4brn42bjsj48brbvg3ixsciph";
      name = "avoid_overwriting_gio_extra_modules_env_var.patch";
    })
  ...
  ];

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;
  buildInputs = [ bash ];
  nativeBuildInputs = [ makeWrapper ];
  postPatch = ''
    patchShebangs --host neofetch
  '';

  postInstall = ''
    wrapProgram $out/bin/neofetch \
      --prefix PATH : ${
        lib.makeBinPath (lib.optional (!stdenvNoCC.isOpenBSD) pciutils ++ lib.optional x11Support ueberzug)
      }
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/etc"
  ];

  meta = with lib; {
    description = "Fast, highly customizable system info script";
    homepage = "https://github.com/dylanaraps/neofetch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ konimex ];
    mainProgram = "neofetch";
  };
}
