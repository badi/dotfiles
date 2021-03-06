

let

  pkgs = import <nixpkgs> {};

  # to get the new set of hashes, run
  # nix-prefetch-git git://github.com/NixOS/nixpkgs-channels refs/heads/nixpkgs-unstable
  hashes = {

    "2016-12-05" = {
      rev = "497e6d2f1d149f5fbe004e15fe8c384eed993943";
      sha256 = "1mh1pmgfi6xrfhx3c7r47iip06w66r9xzqwda79z73hmgq5zbvhx";
    };

    "2017-01-02" = {
      rev = "1fa75a5bb7cdb9f2413d8b20726ce69523bfe4c6";
      sha256 = "1m20qfgqnbbxzxdkf5x5kvhj996zw6pkikzsyckghxcpwh38ipcv";
    };

    "2017-01-09" = {
      rev = "50ec3fe1ac93d6059f67396fc7954c17084a1b20";
      sha256 = "04iazr7r744vf0pkaa3wyzprd90dwisfi0rfymh05xpjvmff4w86";
    };

    "2017-01-12" = {
      rev = "60435691f78dc533d49bf30751e1a8328b67367a";
      sha256 = "14404p4k5vsl7crjsd03vcbgymvlwyxj86mmbbcj9hcjdnadh8iw";
    };

    "2017-01-18" = {
      rev = "460b43dbfe8f21253637be350eb1ef1d586eaf5e";
      sha256 = "19hkwa3yx33z42jprfkdcdabcdrg13cjwwf7s36fzn8i9rlp8bls";
    };

    "2017-01-22" = {
      rev = "cb602a472885f0b32c917b73ec1e5353f8e5e450";
      sha256 = "178xwvb9qjw43da2frd8q5zmli2zm2rxm0vbx68wv8myhhlmpwgj";
    };

    "2017-02-17" = {
      rev = "89a036506396dd869474a32e984f5cab5c07992a";
      sha256 = "04fxjh5ca41rlnvc4ggbgh41j4mkqj685inxj2xbm9i8giabncw1";
    };

    "2017-04-18" = {
      rev = "8d491ec6c69b8649a7f4824f304e5e29ebdf6e00";
      sha256 = "012cmviay8wh9q9hvx8kv12qsqy3dbvnsqgqpiff32cssm9r8vk1";
    };

    "2017-05-30" = {
      rev = "ec9a23332f06eca2996b15dfd83abfd54a27437a";
      sha256 = "09d225y0a4ldx08b5rfhy7jk4qp0nj4q7xsjb49hvb5an79xmgdl";
    };

    "2017-09-02" = {
      rev = "991654fa4ab7be07ce70b02bcc935491239a52c5";
      sha256 = "0365f340xcbx9vl4cfkjv0i9330jsv7i6dcmpqgk7wpsnx52sl6m";
    };

    "2017-10-15" = {
      rev = "5a21efdcdf7c3f4349192036e661247e2cd07916";
      sha256 = "1c7bjp25mlhjww0ngw3cabh4s92wmsv53l59b53cm6pjd0c4ijc1";
    };

  };

  origin = hashes."2017-10-15" // {
    owner = "NixOS";
    repo = "nixpkgs-channels";
  };

  src = pkgs.fetchFromGitHub origin;

in

import src {}
