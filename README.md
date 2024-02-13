# muse-sounds-manager-nix

This is an **unofficial** package of the Muse Sounds Manager based on their RPM package.

Since their download URL is not stateful an archived version is used. (Hint to the Muse Team, if you read this PLEASE fix it <3). And thx for the awesome work on Musescore btw.

You can add this flake to your flake.nix like this
```
muse-sounds-manager.url = "github:thilobillerbeck/muse-sounds-manager-nix";
```

now you can use the package like this for example
```
muse-sounds-manager.packages.x86_64-linux.muse-sounds-manager
```
