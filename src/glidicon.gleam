import gleam/bit_array
import gleam/crypto
import gleam/int
import gleam/list
import glee_gd as egd

pub opaque type Identicon {
  Identicon(hash: BitArray, color: RGB, image: String)
}

pub type RGB =
  #(Int, Int, Int)

pub fn create(from input: String) -> Identicon {
  identicon()
  |> set_hash(input)
  |> set_color
  |> set_image
}

pub fn color(identicon: Identicon) {
  identicon.color
}

pub fn hash(identicon: Identicon) {
  identicon.hash
}

pub fn image(identicon: Identicon) {
  identicon.image
}

fn identicon() -> Identicon {
  Identicon(<<>>, #(0, 0, 0), "")
}

fn set_hash(identicon: Identicon, input: String) -> Identicon {
  Identicon(
    ..identicon,
    hash: crypto.hash(crypto.Md5, bit_array.from_string(input)),
  )
}

fn set_color(identicon: Identicon) -> Identicon {
  let assert <<r, g, b, _rest:bits>> = identicon.hash
  Identicon(..identicon, color: #(r, g, b))
}

fn set_image(identicon: Identicon) -> Identicon {
  Identicon(
    ..identicon,
    image: identicon.hash
      |> chunk
      |> mirror_chunks
      |> list.flatten
      |> add_indices
      |> remove_odd_values
      |> calculate_diagonals
      |> draw_image(identicon.color),
  )
}

fn chunk(bits: BitArray) -> List(#(Int, Int, Int)) {
  case bits {
    <<a, b, c, rest:bits>> -> [#(a, b, c), ..chunk(rest)]
    _ -> []
  }
}

fn mirror_chunks(chunks: List(#(Int, Int, Int))) {
  list.map(chunks, fn(chunk) {
    let #(a, b, c) = chunk
    [a, b, c, b, a]
  })
}

fn add_indices(bits: List(Int)) {
  bits |> list.index_map(fn(val, index) { #(index, val) })
}

fn remove_odd_values(bits: List(#(Int, Int))) {
  list.filter(bits, fn(bit) { int.is_even(bit.1) })
}

fn calculate_diagonals(bits: List(#(Int, Int))) {
  list.map(bits, fn(bit) {
    let #(index, _val) = bit
    let horizontal = index % 5 * 50
    let vertical = index / 5 * 50
    let top_left = #(horizontal, vertical)
    let bottom_right = #(horizontal + 50, vertical + 50)
    #(top_left, bottom_right)
  })
}

fn draw_image(diagonals: List(#(#(Int, Int), #(Int, Int))), color: RGB) {
  let image = egd.create(250, 250)
  let fill_color = egd.color(color)

  list.each(diagonals, fn(diagonal) {
    let #(top_left, bottom_right) = diagonal
    egd.filled_rectangle(image, top_left, bottom_right, fill_color)
  })

  egd.render(image)
}
