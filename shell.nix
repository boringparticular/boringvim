{
  nixpkgs ? <nixpkgs>,
  pkgs ? (import nixpkgs { }),
}:
pkgs.mkShell {
  packages = with pkgs; [
    nixd
    nixfmt-rfc-style
    nix-doc
    nil
    stylua
  ];
}
