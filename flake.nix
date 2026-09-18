{
  description = "NIFTI to DICOM creation with Python";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-24.05/nixexprs.tar.xz";
  };
  outputs = { self, nixpkgs }:
  let
    # https://nixcademy.com/posts/1000-instances-of-flake-utils/#the-alternative
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "i686-linux" ];
    eachSupportedSystem = nixpkgs.lib.genAttrs supportedSystems;
  in {
    packages = eachSupportedSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        nii2dcm = with pkgs.python311Packages; buildPythonPackage {
          pname = "nii2dcm";
          version = "0.0.0+unknown";
          src = ./.;
          pyproject = true;
          patches = [
            (pkgs.writeText "setup.py.patch" ''
              diff --git a/setup.py b/setup.py
              index 9f8c9e7..4422ec0 100644
              --- a/setup.py
              +++ b/setup.py
              @@ -3,5 +3,5 @@ from dunamai import Version, Style
 
               setup(
                   name="nii2dcm",
              -    version=Version.from_any_vcs().serialize(metadata=False, style=Style.SemVer),
              +    version="0.0.0+dev",
               )
              \ No newline at end of file
            '')
            (pkgs.writeText "setup.cfg.patch" ''
              diff --git a/setup.cfg b/setup.cfg
              index d189b02..d4e65a7 100644
              --- a/setup.cfg
              +++ b/setup.cfg
              @@ -16,12 +16,11 @@ long_description_content_type = text/markdown
               packages = find:
               python_requires = <3.12
               install_requires =
              -    numpy==1.23.2
              -    matplotlib==3.6.2
              -    nibabel==5.0.0
              -    pydicom==2.3.0
              -    twine==4.0.2
              -    dunamai==1.18.0
              +    numpy~=1.23
              +    matplotlib~=3.6
              +    nibabel~=5.0
              +    pydicom~=2.3
              +    dunamai~=1.18
               include_package_data=True
 
               [options.entry_points]
              '')
          ];
          build-system = [
            wheel
            setuptools
          ];
          propagatedBuildInputs = [
            numpy
            matplotlib
            nibabel
            pydicom
            twine
            dunamai
          ];
        };
      in {
        default = nii2dcm;
        nii2dcm = nii2dcm;
      });
  };
}
