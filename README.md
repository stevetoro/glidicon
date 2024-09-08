# glidicon

[![Package Version](https://img.shields.io/hexpm/v/glidicon)](https://hex.pm/packages/glidicon)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glidicon/)

```sh
gleam add glidicon
```
```gleam
import glidicon

pub fn main() {
  let image = glidicon.create("gleam") |> glidicon.image
  // Enjoy your Identicon.
}
```

Further documentation can be found at <https://hexdocs.pm/glidicon>.

## Development

```sh
gleam test  # Run the tests
```
