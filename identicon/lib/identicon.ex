defmodule Identicon do
  def main input do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  def hash_input input do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid (%Identicon.Image{hex: hex} = image) do
    hex
    |> Enum.chunk(3)
    |> Enum.map(fn(el) -> mirror_row el end)
  end

  def mirror_row [a, b, c] do
    [a, b, c, b, a]
  end
end
