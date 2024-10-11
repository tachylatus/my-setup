# GPG (GnuPG)

- Create interactively: `gpg --full-generate-key`
  - RSA and RSA (default)
  - Key size 4096
  - Key does not expire
- List: `gpg --list-keys --keyid-format=long`
  ```
  pub   rsa4096/8454DF309A76CA3A 2022-12-16 [SC]
        EB75F0EE058C9F7638CE50338454DF309A76CA3A
  uid                 [ultimate] Helge Willum Thingvad <1019305+tachylatus@users.noreply.github.com>
  sub   rsa4096/3D9A02CBD101FFCD 2022-12-16 [E]
  ```
- Trust the new key:
  - `gpg --edit-key EB75F0EE058C9F7638CE50338454DF309A76CA3A`
  - `trust`
  - `5` (ultimate)
  - `y` (yes)
  - `save`
- Export public key:
  - `gpg --export --armor EB75F0EE058C9F7638CE50338454DF309A76CA3A`
  - Use public key anywhere
- Backup private key:
  - `gpg --export-secret-keys --export-options backup --armor EB75F0EE058C9F7638CE50338454DF309A76CA3A`
  - Save private key to secure location
- Backup ownertrust:
  - `gpg --export-ownertrust`
- Restore private key:
  - `gpg --import`
  - Paste private key
- Restore ownertrust:
  - `gpg --import-ownertrust`
  - Paste ownertrust
