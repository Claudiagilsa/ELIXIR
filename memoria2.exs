defmodule MemoryGame do
  @alphabet_letters ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z)a

  @correct_pairs [
    {'A', 'a'}, {'z', 'Z'}, {'M', 'm'}, {'j', 'J'}
  ]

  def start do
    IO.puts "Ingrese nickname:"
    nickname = IO.gets("") |> String.trim()

    game_state = %{player: nickname, correct_pairs: 0, incorrect_pairs: 0, lives: 3}
    game_state = initialize_board(game_state)

    IO.puts "Jugador: #{game_state.player}"
    IO.puts "Pares correctos: #{game_state.correct_pairs}"
    IO.puts "Pares incorrectos: #{game_state.incorrect_pairs}"
    IO.puts "Vidas: #{game_state.lives}"

    play_game(game_state)
  end

  def initialize_board(game_state) do
    shuffled_letters = Enum.shuffle(@alphabet_letters)
    board = shuffled_letters |> Enum.shuffle()

    Map.put(game_state, :board, board)
  end

  def play_game(game_state) do
    case {game_state.lives, game_state.correct_pairs} do
      {0, _} -> end_game(game_state)
      {_, correct_pairs} when correct_pairs >= 4 ->
        end_game(game_state)
      _ ->
        IO.puts "\nSeleccione dos cartas (1-26):
      [ -1- ]  [ -2- ]  [ -3- ]  [ -4- ]
      [ -5- ]  [ -6- ]  [ -7- ]  [ -8- ]
      [ -9- ] [ -10- ] [ -11- ] [ -12- ]
      [ -13- ] [ -14- ] [ -15- ] [ -16- ]
      [ -17- ] [ -18- ] [ -19- ] [ -20- ]
      [ -21- ] [ -22- ] [ -23- ] [ -24- ]
      [ -25- ] [ -26- ]
      "
        IO.puts("Ingrese la posición de una carta (1-26):")
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
      case {card1_letter, card2_letter} do
        {c1, c2} when {c1, c2} in @correct_pairs ->
          update_pairs(game_state, :correct_pairs, 1)

        {c1, c2} when {c1, c2} not in @correct_pairs ->
          update_pairs(game_state, :incorrect_pairs, 1)

        _ -> decrease_lives(game_state)
      end

    updated_state = Map.put(updated_state, :board, updated_board)
    display_board(updated_state)

    play_game(updated_state)
  end

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
    IO.puts("Pares correctos: #{game_state.correct_pairs}")
    IO.puts("Pares incorrectos: #{game_state.incorrect_pairs}")
    IO.puts("Vidas: #{game_state.lives}")
  end

  def end_game(game_state) do
    IO.puts("\n=== Juego Terminado ===")
    IO.puts("Jugador: #{game_state.player}")
    IO.puts("Pares correctos: #{game_state.correct_pairs}")
    IO.puts("Pares incorrectos: #{game_state.incorrect_pairs}")
    IO.puts("Vidas: #{game_state.lives}")

    case game_state.correct_pairs >= 4 do
      true -> IO.puts("¡Has encontrado todos los pares correctos!")
      false -> IO.puts("Has agotado tus vidas. Mejor suerte la próxima vez.")
    end
  end
end

MemoryGame.start()
