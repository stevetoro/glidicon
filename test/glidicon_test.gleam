import gleam/bit_array
import gleam/list
import gleeunit
import gleeunit/should
import glidicon
import simplifile

pub fn main() {
  gleeunit.main()
}

pub fn identicon_create_test() {
  let file_names = [
    "erlang", "joearmstrong", "elixir", "josevalim", "gleam", "louispilfold",
  ]

  list.each(file_names, fn(file_name) {
    glidicon.create(file_name)
    |> glidicon.image
    |> should_be_fixture(file_name)
  })
}

fn should_be_fixture(image: String, file_name: String) {
  let image_b64 =
    bit_array.from_string(image)
    |> bit_array.base64_encode(False)

  let file_b64 =
    simplifile.read_bits("test/fixtures/" <> file_name <> ".png")
    |> should.be_ok
    |> bit_array.base64_encode(False)

  image_b64 |> should.equal(file_b64)
}
