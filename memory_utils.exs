defmodule S2.Games.Memory.MemoryUtils do
  def board() do
    """
    [ -1- ]  [ -2- ]  [ -3- ]  [ -4- ]
    [ -5- ]  [ -6- ]  [ -7- ]  [ -8- ]
    [ -9- ] [ -10- ] [ -11- ] [ -12- ]
    """
  end

  def alphabet_map() do
      vocales = ["a", "e", "i", "o", "u"]
      alphabet = for letter <- String.graphemes("abcdefghijklmnopqrstuvwxyz") do
        case letter in vocales do
          true -> {String.to_atom(letter), {String.upcase(letter), letter, :vocal, :notfound}}
          false -> {String.to_atom(letter), {String.upcase(letter), letter, :consonante, :notfound}}
        end
      end

      Map.new(alphabet) #%{a: {"A","a",:vocal, :notfound}, b:{"B", "b", :consonante, :notfound},...}
  end

  def load_board(sel_letters, alphabet) do
    letters = Enum.flat_map(sel_letters, &Tuple.to_list/1)
    range_letters = 1..12 |> Enum.to_list |> Enum.shuffle

    pos_pares = range_letters
              |> Enum.map(fn p -> to_string(p) end) #["5", "7", "1"...]
              |> Enum.chunk_every(2) #[["5","7"], ...]
              |> Enum.map(fn par -> {String.to_integer(Enum.at(par,0)),String.to_integer(Enum.at(par,1))} end) #[{5,7}, ...]
              |> Enum.zip(sel_letters) #[]
                  |> Map.new() #%{{5,7} => {"R","r"}, ...}
                  |> Enum.map(fn {k,v} ->
                  tipo = Map.get(alphabet, String.to_atom(elem(v,1))) #:vocal / :consonante
                  {k, tipo}
              end)



    {pos_pares, Enum.zip(letters,range_letters) |> Map.new}

  end

  def get_vowels(alpha_map, l_vowels) when length(l_vowels) < 3 do
      claves_vocales = Enum.filter(alpha_map, fn{_k,v} -> elem(v,2) == :vocal end) |> Enum.into(%{}) |> Map.keys
      clave_v = Enum.random(claves_vocales)
      valor_v = Map.get(alpha_map, clave_v)
      par = {elem(valor_v, 0), elem(valor_v,1)}
      l_vocales = unless Enum.member?(l_vowels, par), do: [par | l_vowels], else: l_vowels
      get_vowels(alpha_map, l_vocales)
  end

  def get_vowels(_, l_vowels), do: l_vowels


  def get_consonants(alpha_map, l_conson) when length(l_conson) < 3 do
    claves_consonantes= Enum.filter(alpha_map, fn{_k,v} -> elem(v,2) == :consonante end) |> Enum.into(%{}) |> Map.keys
    clave_c = Enum.random(claves_consonantes)
    valor_c = Map.get(alpha_map, clave_c)
    par = {elem(valor_c, 0), elem(valor_c,1)}
    l_consonantes = unless Enum.member?(l_conson, par), do: [par | l_conson], else: l_conson
    get_consonants(alpha_map, l_consonantes)
  end

  def get_consonants(_, l_conson), do: l_conson




end
