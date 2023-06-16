defmodule MemoryGame do
  @alphabet_letters ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z)a


  def start do
    IO.puts "Ingrese nickname:"
    nickname = IO.gets("") |> String.trim()

    game_state = %{player: nickname, vowel_pairs: 0, consonant_pairs: 0, lives: 3}
    game_state = initialize_board(game_state)

    IO.puts "Jugador: #{game_state.player}"
    IO.puts "Pares vocales: #{game_state.vowel_pairs}"
    IO.puts "Pares consonantes: #{game_state.consonant_pairs}"
    IO.puts "Vidas: #{game_state.lives}"

    play_game(game_state)
  end

  def initialize_board(game_state) do
    shuffled_letters = Enum.shuffle(@alphabet_letters)
    vowel_letters = shuffled_letters |> Enum.take(3)
    consonant_letters = shuffled_letters |> Enum.drop(3) |> Enum.take(3)

    board = Enum.concat(vowel_letters, consonant_letters) |> Enum.shuffle()

    Map.put(game_state, :board, board)
  end

  def play_game(game_state) do
    case {game_state.lives, game_state.vowel_pairs, game_state.consonant_pairs} do
      {0, _, _} -> end_game(game_state)
      {_, vowel_pairs, consonant_pairs} when vowel_pairs + consonant_pairs >= 6 ->
        end_game(game_state)
      _ ->
        IO.puts "\nSeleccione dos cartas (1-12):
      [ -1- ]  [ -2- ]  [ -3- ]  [ -4- ]
      [ -5- ]  [ -6- ]  [ -7- ]  [ -8- ]
      [ -9- ] [ -10- ] [ -11- ] [ -12- ]
      "
        IO.puts("Ingrese la posición de una carta (1-12):")
        card1 = get_card_choice()
        card2 = get_card_choice()
        handle_card_selection(card1, card2, game_state)
    end
  end


  def get_card_choice() do
    input = IO.gets("") |> String.trim()
    String.to_integer(input)
  end

  def handle_card_selection(card1, card2, game_state) do
    board = game_state.board
    card1_letter = board |> Enum.at(card1 - 1)
    card2_letter = board |> Enum.at(card2 - 1)

    updated_board =
      board
      |> List.replace_at(card1 - 1, :matched)
      |> List.replace_at(card2 - 1, :matched)

    updated_state =
      case {to_lowercase(card1_letter), to_lowercase(card2_letter)} do
        {c1, c2} when c1 == c2 ->
          case {String.to_existing_atom(card1_letter, :utf8), String.to_existing_atom(card2_letter, :utf8)} do
            {atom1, atom2} when atom1 == atom2 ->
              update_pairs(game_state, :vowel_pairs, 1)
            _ ->
              update_pairs(game_state, :consonant_pairs, 1)
          end

        _ ->
          decrease_lives(game_state)
      end

    updated_state = Map.put(updated_state, :board, updated_board)
    display_board(updated_state)

    play_game(updated_state)
  end


  defp to_lowercase(nil), do: nil
  defp to_lowercase(letter) when is_atom(letter), do: String.downcase(Atom.to_string(letter))
  defp to_lowercase(letter), do: String.downcase(letter)


  def update_pairs(game_state, pair_type, increment) do
    current_pairs = Map.get(game_state, pair_type)
    updated_pairs = current_pairs + increment
    Map.put(game_state, pair_type, updated_pairs)
  end

  def decrease_lives(game_state) do
    current_lives = Map.get(game_state, :lives)
    updated_lives = current_lives - 1
    Map.put(game_state, :lives, updated_lives)
  end

  def display_board(game_state) do
    IO.puts("\n=== Tablero ===")
    Enum.chunk(game_state.board, 4) |> Enum.each(&IO.inspect/1)
    IO.puts("===============")

    IO.puts("\nJugador: #{game_state.player}")
    IO.puts("Pares vocales: #{game_state.vowel_pairs}")
    IO.puts("Pares consonantes: #{game_state.consonant_pairs}")
    IO.puts("Vidas: #{game_state.lives}")
  end

  def end_game(game_state) do
    IO.puts("\n=== Juego Terminado ===")
    IO.puts("Jugador: #{game_state.player}")
    IO.puts("Pares vocales: #{game_state.vowel_pairs}")
    IO.puts("Pares consonantes: #{game_state.consonant_pairs}")
    IO.puts("Vidas: #{game_state.lives}")

    case game_state.vowel_pairs + game_state.consonant_pairs >= 6 do
      true -> IO.puts("¡Has encontrado todos los pares!")
      false -> IO.puts("Has agotado tus vidas. Mejor suerte la próxima vez.")
    end
  end
end

MemoryGame.start()
